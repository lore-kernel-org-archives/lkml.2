Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab1IIS2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:28:15 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45711 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759649Ab1IIS2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:28:13 -0400
Date: Fri, 9 Sep 2011 11:28:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, rtitmuss@logitech.com, ogay@logitech.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Subject: Re: [PATCH v3] HID: Add full support for Logitech Unifying receivers
Message-ID: <20110909182805.GH32383@core.coreip.homeip.net>
References: <1314259880-7854-1-git-send-email-benjamin.tissoires@gmail.com>
 <CAN+gG=HZsREeuc0h53juGg3L6kseuEUeiBWe8ZCaNLaVpth1Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN+gG=HZsREeuc0h53juGg3L6kseuEUeiBWe8ZCaNLaVpth1Qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 02:43:32PM +0200, Benjamin Tissoires wrote:
> > +
> > +       usbhid_submit_report(dj_rcv_hiddev, &report, USB_DIR_OUT);
> 
> This is not working when the receiver is paired to a keyboard. When
> the session launches, Gnome try to send leds commands to the keyboard
> and this results in an oops.
> 
> Using a  pointer to the struct hid_report solves the crash.
> 
> However, Dmitry, you told us about a DMA stack problem. Can you give
> us a better way to handle that?
> 

Actually it is OK, usbhid_submit_report internally allocates DMA_safe
memory for raw report and copies the data for you.

Thanks.

-- 
Dmitry
