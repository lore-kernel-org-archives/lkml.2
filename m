Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2JFVLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 17:11:46 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:24159 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2JFVLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 17:11:42 -0400
Date: Sat, 6 Oct 2012 23:11:11 +0200
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
Message-ID: <20121006231111.6350c014@endymion.delvare>
In-Reply-To: <6F756B9E-DC87-4EF6-BB09-8A69A5F8C999@enac.fr>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121006220421.47f5fd56@endymion.delvare>
	<6F756B9E-DC87-4EF6-BB09-8A69A5F8C999@enac.fr>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2012 22:30:00 +0200, Stéphane Chatty wrote:
> Le 6 oct. 2012 à 22:04, Jean Delvare a écrit :
> > Looks like the wrong place for this driver. HID-over-USB support lives
> > under drivers/hid, so your driver should go there as well. Not only
> > this will be more consistent, but it also makes more sense: your driver
> > is a user, not an implementer, of the I2C layer, so it doesn't belong
> > to drivers/i2c.
> 
> This is a question I asked a few months back, but apparently not all points of views had been expressed at the time. Currently, HID-over-USB lives in drivers/hid, but HID-over-BT lives in drivers/bluetooth. When I asked, Jiri explained that he maintained HID-over-USB and Marcel maintained HID-over-BT, which explained the choices made. Let's try to summarize what we know now:
> 
> The question is what drives the choice of where to put HID-over-XXX, among the following
>  1- who the maintainer is. Here, Benjamin will probably maintain this so it does not help.
>  2- dependencies. HID-over-XXX depends on HID as much as it depends on XXX, so it does not help.
>  3- data flow. Indeed, HID is a client of HID-over-XXX which is a client of XXX. Are there other parts of the kernel where this drives the choice of where YYY-over-XXX lives?
> 
> Jiri, Marcel, Greg, others, any opinions?

My vote is a clear 3. It took me a few years to kick all users (as
opposed to implementers) of i2c from drivers/i2c and finding them a
proper home, I'm not going to accept new intruders. Grouping drivers
according to what they implement makes it a lot easier to share code
and ideas between related drivers. If you want to convince yourself,
just imagine the mess it would be if all drivers for PCI devices lived
under drivers/pci.

-- 
Jean Delvare
