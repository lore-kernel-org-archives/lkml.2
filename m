Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2LSXH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:07:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2LSXHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:07:18 -0500
Date: Wed, 19 Dec 2012 15:07:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Joe Perches'" <joe@perches.com>,
        "'Devendra Naga'" <devendra.aaru@gmail.com>,
        "'Ilho Lee'" <ilho215.lee@samsung.com>
Subject: Re: [PATCH v2] backlight: add lms501kf03 LCD driver
Message-Id: <20121219150716.d37f5e75.akpm@linux-foundation.org>
In-Reply-To: <005201cddcfc$36ac4020$a404c060$%han@samsung.com>
References: <005201cddcfc$36ac4020$a404c060$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012 17:46:46 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> Add the lms501kf03 LCD panel driver. The lms501kf03 LCD panel (800
> x 480) driver uses 3-wired SPI inteface.

Looks OK.

> +static unsigned int before_power;

This is unused.  Can I zap it?


--- a/drivers/video/backlight/lms501kf03.c~backlight-add-lms501kf03-lcd-driver-fix
+++ a/drivers/video/backlight/lms501kf03.c
@@ -388,7 +388,6 @@ static int lms501kf03_remove(struct spi_
 }
 
 #if defined(CONFIG_PM)
-static unsigned int before_power;
 
 static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
 {
@@ -396,8 +395,6 @@ static int lms501kf03_suspend(struct spi
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
-	before_power = lcd->power;
-
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
 	 * regardless of status.
_

