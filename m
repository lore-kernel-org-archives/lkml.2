Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab2CHL25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:28:57 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:50088 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2CHL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:28:54 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: App+APqWWE9V5qjTPGdsb2JhbABDiXqqFgOBChkBAQEBNzSCCgEBBAEyASMjEAgDRhQlChqIGAm6QBOKcIUIYwSVRIV1jQg
X-IronPort-AV: E=Sophos;i="4.73,551,1325458800"; 
   d="scan'208";a="1820922588"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 8 Mar 2012 12:30:09 +0100
To: =?iso-8859-1?Q?St=E9phane?= Chatty <chatty@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] HID: autoload hid-multitouch as needed
Message-ID: <20120308113009.GA11416@polaris.bitmath.org>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
 <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>
 <alpine.LNX.2.00.1203072234550.29034@pobox.suse.cz>
 <20120308105737.GA11201@polaris.bitmath.org>
 <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stéphane,

> > What if we were to change the definition of a HID device on the
> > modalias level?
> > 
> > In practise, a HID device can be either an usb device, a hid device,
> 
> Just to be sure: do you mean "bluetooth device"? or is there such a
> thing as a hid device per se? I'm asking because I've always been
> surprised at seeing usbhid/ in hid/, which kind of breaks the
> potential symmetry between USB and Bluetooth wrt hid.

Oops, yes, I meant bluetooth devices.

> > a single interface on a usb bus, a special class determined by examining
> > the reports, etc. Yet, the hid modalias contains only bus type, vendor
> > and product id. This is true for the generic usb and bluetooth drivers
> > (and some very special drivers), but not really for the other devices.
> > If we were to extend the modalias description, we could cater for a
> > whole tree of hid devices. For instance, the usb id 1234 could be
> > handled by the generic usb bus driver. The multitouch sub-device
> > 1234:MT could be handled by hid-multitouch. The mouse device
> > 1234:Mouse could be handled by some other driver, etc. All the driver
> > handling could be automated in userland using the same udev mechanism
> > we have today, if only the hid uevents were modified to incorporate
> > the needed extra information.
> 
> No comments on this, I need to read up on modaliases before being
> able to comment at all. I have a vague feeling that we are going to
> end up debating where it is decided to assign a device to a driver
> (today it's done in the kernel, you seem to suggest userland), but I
> know too little about modaliases to be sure.

The device-driver matching is done in the kernel, but driver (aka
module) loading is done from userland. The crux is to be able to tell
userland what driver to load for a certain device. In this case, it
means giving more information to userland via the device/modalias
construct. Or at least, that is the question. :-)

Thanks,
Henrik
