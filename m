Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2I1OH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:07:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081Ab2I1OHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:07:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120928135459.GH7916@n2100.arm.linux.org.uk>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
	<CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
	<20120928084626.GB7916@n2100.arm.linux.org.uk>
	<CACVXFVOOVvf4xOABnv1FqPOMH6_XwFcH-ZTfBDojQrZJyypT+A@mail.gmail.com>
	<20120928135459.GH7916@n2100.arm.linux.org.uk>
Date: Fri, 28 Sep 2012 22:07:22 +0800
Message-ID: <CACVXFVPs-TSoep3T_Pn3PgNEKWYSCiRNSnNOD66TcERUQJmmeA@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix possible missing of device probe
From: Ming Lei <ming.lei@canonical.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: anish singh <anish198519851985@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 9:55 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>> I do not mention threads case in one CPU because the context in
>> which device_add runs will always see the driver added into
>
> There you go again.  Look at my _much_ better description of the problem
> and you'll notice that device_add has nothing to do with this.

OK, I explain it again:

CPU0						CPU1

driver_register
	...
	bus_add_driver
		driver_attach
						device_add(devb)

		klist_add_tail(klist_drivers)

When device_add(devb) is run just after completion of driver_attach
and before klist_add_tail(klist_drivers), the 'devb' can't be probed
in device_add because the driver hasn't been added into bus,
and it wasn't be probed in driver_attach because driver_attach didn't
see the device in the bus.

So the 'devb' will be missed to be probed in the bus, won't it?


Thanks,
--
Ming Lei
