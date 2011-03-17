Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1CQUfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:35:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49180 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1CQUfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:35:08 -0400
Date: Thu, 17 Mar 2011 14:35:05 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: davidb@codeaurora.org, dwalker@fifo99.com,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Thomas Glexiner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PM8921 MFD V3 3/6] gpio: pm8xxx-gpio: Add pm8xxx gpio driver
Message-ID: <20110317203505.GI12824@angua.secretlab.ca>
References: <1300328641-3855-1-git-send-email-adharmap@codeaurora.org>
 <1300328641-3855-4-git-send-email-adharmap@codeaurora.org>
 <20110317180013.GJ9597@angua.secretlab.ca>
 <4D826EAA.3070807@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D826EAA.3070807@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 01:27:22PM -0700, Abhijeet Dharmapurikar wrote:
> Grant Likely wrote:
> >On Wed, Mar 16, 2011 at 07:23:58PM -0700, adharmap@codeaurora.org wrote:
> >>Add support for GPIO on Qualcomm PM8xxx PMIC chips.
> >>
> >>Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> >
> >Minor points below, but otherwise:
> >
> >Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Thanks Grant, can you review (and ack) drivers/mfd/pm8xxx-mpp.c? Now
> that I think, mpp is basically a gpio device, so should I move it to
> drivers/gpio?
> 
> mpp is the 4th patch in this series and can be found here.
> https://patchwork.kernel.org/patch/640891/

I've only looked briefly, but it appears to be fine.

Yes, you should move it to drivers/gpio

g.

> 
> >>diff --git a/drivers/gpio/pm8xxx-gpio.c b/drivers/gpio/pm8xxx-gpio.c
> >>new file mode 100644
> >>index 0000000..8995764
> >>--- /dev/null
> >>+++ b/drivers/gpio/pm8xxx-gpio.c
> >>@@ -0,0 +1,455 @@
> >>+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
> >
> >Nit: first line should be '/*' and start the comments on the second
> >line.  It also helps for the first line of the comment block to be a
> >single line description of what the driver actually is.  (a
> >description, not a filename).
> >
> >>+ *
> >>+ * This program is free software; you can redistribute it and/or modify
> >>+ * it under the terms of the GNU General Public License version 2 and
> >>+ * only version 2 as published by the Free Software Foundation.
> >>+ *
> >>+ * This program is distributed in the hope that it will be useful,
> >>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>+ * GNU General Public License for more details.
> >>+ */
> >>+
> >>+/*
> >>+ * Qualcomm PMIC8XXX GPIO driver
> >
> >Heh, this is the line I just was talking about should appear at the
> >top of the file.  :-)
> 
> Ok I will make this change for all the files in the patchset.
> 
> >>+
> >>+static int __init pm_gpio_init(void)
> >>+{
> >>+	int rc = platform_driver_register(&pm_gpio_driver);
> >>+
> >>+	return rc;
> >>+}
> >
> >Or simply:
> >
> >	return platform_driver_register(&pm_gpio_driver);
> 
> yes  will do.
> 
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc. The
> Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> Forum.
