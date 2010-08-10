Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0HJMBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:01:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35262 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab0HJMA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:00:57 -0400
Date: Tue, 10 Aug 2010 14:00:55 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: rtc-linux@googlegroups.com,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Wells <wellsk40@gmail.com>
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
	for the LPC32XX SoC
Message-ID: <20100810120055.GD11268@pengutronix.de>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com> <1281370650-29520-2-git-send-email-wellsk40@gmail.com> <20100810102507.GB4268@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100810102507.GB4268@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> > +	retval = request_irq(rtc->irq, lpc32xx_rtc_alarm_interrupt,
> > +		IRQF_DISABLED, "rtcalarm", rtc);
> > +	if (retval < 0) {
> > +		dev_err(&pdev->dev, "Can't request interrupt\n");
> > +		goto err_free_irq;
> > +	}
> 
> I saw that a number of rtc-drivers register their irq after they
> register the device. I wonder if this is OK here? Couldn't it happen
> that after rtc_device_register() there is a preemption and another
> process could set the alarm? Then there is a race between interrupts
> already enabled and no handler available, no?
If you do it the other way around the irq might trigger and the handler
reports an irq for a device that doesn't exist yet.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
