Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2KEMwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:52:11 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:33462 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2KEMwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:52:08 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnisAPG1l1BV5h1yPGdsb2JhbABEhS6FI7diAgKBCBkBAQEBHxkNJ4IeAQEEAScTHCMQCAMtGRQNGAoaExuHXQMJCrA0DYlUFIsFcjCBDYFEglBhA5QmgVSFe4U5iAGBYxeBIQ
X-IronPort-AV: E=Sophos;i="4.80,715,1344204000"; 
   d="scan'208";a="223738725"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 5 Nov 2012 13:57:31 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/11] HID: hid-multitouch: get rid of usbhid
 depedency for general path
Message-ID: <20121105125731.GA814@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
 <1351241067-9521-12-git-send-email-benjamin.tissoires@gmail.com>
 <20121029225748.GA15632@polaris.bitmath.org>
 <CAN+gG=GNucfg4-wCBZQtz0yJDjpTD_56Js3d68nm8VFi1UhZAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=GNucfg4-wCBZQtz0yJDjpTD_56Js3d68nm8VFi1UhZAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> >> This patch factorizes the hid set_feature command by using
> >> hid_device->hid_output_raw_report instead of direclty relying on
> >> usbhid. This makes the driver usb independant.
> >>
> >> However I still can't remove the 2 usb related headers because the
> >> function mt_resume has a specific patch for usb devices.
> >>
> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> >> ---
> >>  drivers/hid/hid-multitouch.c | 63 ++++++++++++++++++++++++++------------------
> >>  1 file changed, 37 insertions(+), 26 deletions(-)
> >
> > In my drawer, I have a patchset that aims to remove all usbhid
> > dependence, from all the drivers. Perhaps the attached patch is
> > something to consider here?
> 
> yep, removing usbhid dependencies is a good thing.
> See my review below :)

I have a tentative patch taking your comments into account, and it is
likely that we want to go that way. However, as to not hold up your
patchset, perhaps we could do without it for now.

Regarding the hardwired usbhid dependency, I think the solution is to
move that code to usbhid itself.

Thanks,
Henrik
