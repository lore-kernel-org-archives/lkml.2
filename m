Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1CCIHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:07:55 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43132 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1CCIHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AY/vycm0Ik4fwQ+1llLCJWQVes1PPzNdOw8o36YSW/4HPdJ/jH0YN8LKAwlI7RiMuo
         NdeAKHxHV/HBhUgBM6QKlog1Q88QKoPZIb1DuL3QlgaXXWIb+tmNHZ0McQ/RZEVoZBYD
         rTXswhlZyYHu7VTNZy+A7VULfDE4ZDQhU6nY0=
Date: Thu, 3 Mar 2011 00:07:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>,
        =?iso-8859-1?Q?St=E9phane?= Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
Message-ID: <20110303080747.GB29929@core.coreip.homeip.net>
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
 <AANLkTi=VfSbbV5xwpacC+8yDUfjR3-S8OW47YPvtZwFX@mail.gmail.com>
 <20110224204300.GA2423@polaris.bitmath.org>
 <AANLkTi=YBYrgf66Md_G2Cas7t__BDD2nozvidYDj0p9W@mail.gmail.com>
 <20110225171911.GA22592@polaris.bitmath.org>
 <20110301175423.GC27560@core.coreip.homeip.net>
 <20110302150227.GA1973@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302150227.GA1973@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 04:02:27PM +0100, Henrik Rydberg wrote:
> Hi Dmitry,
> 
> > > For output devices, the only supported case is EV_LED, which passes
> > > events to the input device. It is probably assumed that
> > > HID_QUIRK_MULTI_INPUT is false for those devices. Jiri?
> > > 
> > 
> > I am probably late to the party fut the above is not true. Here is an
> > example of an USB keyboard (wih LEDs) that is split into two:
> > 
> > I: Bus=0003 Vendor=046d Product=c30e Version=0110
> > N: Name="Logitech HID compliant keyboard"
> > P: Phys=usb-0000:00:1d.0-1.2/input0
> > S:
> > Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input3
> > U: Uniq=
> > H: Handlers=sysrq kbd event3
> > B: PROP=0
> > B: EV=120013
> > B: KEY=1000000000007 ff800000000007ff febeffdff3cfffff fffffffffffffffe
> > B: MSC=10
> > B: LED=7
> > 
> > I: Bus=0003 Vendor=046d Product=c30e Version=0110
> > N: Name="Logitech HID compliant keyboard"
> > P: Phys=usb-0000:00:1d.0-1.2/input1
> > S:
> > Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.1/input/input4
> > U: Uniq=
> > H: Handlers=kbd event4
> > B: PROP=0
> > B: EV=13
> > B: KEY=fff ffffffffffffffff 2000000 387ad800d001 1e000000000000 0
> > B: MSC=10
> > 
> > This was done, most likely, because Logitech decided to reuse usage codes
> > for different keys.
> 
> This looks like different interfaces though, which should be fine. It
> is only in the odd case of mixed input and output reports on the same
> interface that the MULTI_INPUT quirk would ever have any strange
> effect.
> 

Gah, when I looked at it before posting I could swore they were on the
same interface. OK, just ignore me...

Thanks.

-- 
Dmitry
