Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0ENLZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 07:25:51 -0400
Received: from 8bytes.org ([88.198.83.132]:49119 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab0ENLZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 07:25:50 -0400
Date: Fri, 14 May 2010 13:25:48 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: olivier.grenie@dibcom.fr,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jslaby@suse.cz
Subject: Re: WARNING: at lib/dma-debug.c:866 check_for_stack
Message-ID: <20100514112548.GD510@8bytes.org>
References: <AANLkTikyx2eaxaiUCFDSfpmn1UG0t2GOxArz6F4wp1LJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikyx2eaxaiUCFDSfpmn1UG0t2GOxArz6F4wp1LJ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 10:56:46AM +0200, Zdenek Kabelac wrote:
> I've noticed my dvb-t tuner reports this Warning about stack usage for DMA.
> Is there some fix already available ?

int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
                        struct dvb_usb_device_description **desc, int *cold)
{
        u8 b[16];
        s16 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev,0),
                REQUEST_GET_VERSION, USB_TYPE_VENDOR | USB_DIR_IN, 0, 0, b, 16, USB_CTRL_GET_TIMEOUT);

	...
}

The variable b is on the stack and used as the usb transfer buffer. This
should be easy to fix.

	Joerg

