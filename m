Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2DXOXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:23:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47601 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab2DXOW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:22:58 -0400
Subject: Re: [RFC]Is usb port number fixed?
From: anil <anilcoll90@gmail.com>
To: Wang YanQing <udknight@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
In-Reply-To: <20120424021600.GA5283@udknight>
References: <20120423015212.GA7547@udknight>
	 <Pine.LNX.4.44L0.1204231109380.1612-100000@iolanthe.rowland.org>
	 <20120424021600.GA5283@udknight>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Apr 2012 19:52:44 +0530
Message-ID: <1335277364.2094.13.camel@anil-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 10:16 +0800, Wang YanQing wrote:
> On Mon, Apr 23, 2012 at 11:13:06AM -0400, Alan Stern wrote:
> > The port numbers are determined by the hardware -- each set of wires
> > has its own port number.  The numbers have nothing to do with
> > bandwidth.
> Could you figure out the codes in kernel that read out the port number from
> hub, if there is a piece of codes do that things?

The USB specification Table 11-13 describes the hub descriptor in
detail.
The following data structure struct usb_hub_descriptor defined in
"drivers/usb/core/hub.h" of Linux  Kernel source contains information
about the hub descriptor,

                      struct usb_hub_descriptor {
                            _u8 bDescLength;
                          _u8 bDescriptorType;
                             _u8 bNbrPorts;
                       _le16 wHubCharacteristics;
                          _u8 bPwrOn2PwrGood;
                         _u8 bHubContrCurrent;
                                   }

The bNbrPorts  member contains information on the number of
downstream-facing ports the hub supports. The structure which i have
provided is in reference to Linux Kernel Version 2.6 series for Linux
Kernel Version 3.0+, Please consult an expert.
  	Is this information you wanted?

Regards
Anil Nair
--


