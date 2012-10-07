Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab2JGHRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 03:17:30 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:29017 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2JGHR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 03:17:28 -0400
Date: Sun, 7 Oct 2012 09:16:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?ISO-8859-1?B?U3TpcGhhbmU=?= Chatty <chatty@enac.fr>
Cc: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Fabien =?UTF-8?B?QW5kcsOp?= <fabien.andre@gmail.com>,
        =?UTF-8?B?5YqJ5ZiJ6ae/?= <scott.liu@emc.com.tw>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, USB list <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification  
 implementation
Message-ID: <20121007091640.0c21b3f3@endymion.delvare>
In-Reply-To: <3289FFF0-9B90-4F2D-8ECA-EE344911FBC0@enac.fr>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121006220421.47f5fd56@endymion.delvare>
	<6F756B9E-DC87-4EF6-BB09-8A69A5F8C 999@enac.fr>
	<20121006231111.6350c014@endymion.delvare>
	<3289FFF0-9B90-4F2D-8ECA-EE344911FBC0@enac.fr>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2012 23:27:47 +0200, Stéphane Chatty wrote:
> Le 6 oct. 2012 à 23:11, Jean Delvare a écrit :
> > On Sat, 6 Oct 2012 22:30:00 +0200, Stéphane Chatty wrote:
> >> This is a question I asked a few months back, but apparently not all points of views had been expressed at the time. Currently, HID-over-USB lives in drivers/hid, but HID-over-BT lives in drivers/bluetooth. When I asked, Jiri explained that he maintained HID-over-USB and Marcel maintained HID-over-BT, which explained the choices made. Let's try to summarize what we know now:
> >> 
> >> The question is what drives the choice of where to put HID-over-XXX, among the following
> >> 1- who the maintainer is. Here, Benjamin will probably maintain this so it does not help.
> >> 2- dependencies. HID-over-XXX depends on HID as much as it depends on XXX, so it does not help.
> >> 3- data flow. Indeed, HID is a client of HID-over-XXX which is a client of XXX. Are there other parts of the kernel where this drives the choice of where YYY-over-XXX lives?
> >> 
> >> Jiri, Marcel, Greg, others, any opinions?
> > 
> > My vote is a clear 3. It took me a few years to kick all users (as
> > opposed to implementers) of i2c from drivers/i2c and finding them a
> > proper home, I'm not going to accept new intruders. Grouping drivers
> > according to what they implement makes it a lot easier to share code
> > and ideas between related drivers. If you want to convince yourself,
> > just imagine the mess it would be if all drivers for PCI devices lived
> > under drivers/pci.
> 
> 
> Having no strong opinion myself, I'm trying to get to the bottom of this :-) Here, I see two points that need clarification:
> 
> - I'm under the impression that the situation is exactly opposite between i2c and USB: drivers/usb contains lots of drivers for specific devices, but HID-over-USB is in drivers/hid. I actually found this disturbing when reading the HID code for the first time. Mmmm.

Indeed I see a lot of drivers under drivers/usb. I'm glad I am not
responsible for this subsystem ;) I think drivers/pci is a much cleaner
example to follow. If nothing else, grouping drivers by functionality
solves the problem of devices which can be accessed through multiple
transport layers. For devices with multiple functions, we have
drivers/mfd, specifically designed to make it possible to put support
for each function into its dedicated location.

> - given your explanation, I'd say that you would agree to 2 as well, if it meant for instance that HID-over-I2C is neither in drivers/hid nor drivers/i2c. Actually, you don't care whether it is 1, 2, or 3 that drives the choice as long as HID-over-I2C is not in drivers/i2c, do you? :-)

I do care that things are as consistent and logical as possible. I know
sometimes there are borderline cases, or things done a certain way for
historical reasons, but grouping by functionality seems the more
logical and efficient as a rule of thumb.

-- 
Jean Delvare
