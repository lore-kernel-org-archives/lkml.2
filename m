Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab2CLXH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:07:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46235 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757948Ab2CLXH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:07:57 -0400
Message-ID: <1331593676.13200.37.camel@joe2Laptop>
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: Joe Perches <joe@perches.com>
To: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
Cc: rpurdie@rpsys.net, FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 16:07:56 -0700
In-Reply-To: <1331608337.2267.67.camel@debian.Gayathri>
References: <1331608337.2267.67.camel@debian.Gayathri>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 23:12 -0400, Pradeep Subrahmanion wrote:
> Hi ,

Hello yourself.

Just some trivial comments:

> diff --git a/drivers/video/backlight/acer4736_bl.c b/drivers/video/backlight/acer4736_bl.c
[]
Please add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any include

> +static int update_brightness(struct backlight_device *bd)
> +{
> +	u8 intensity = bd->props.brightness;
> +	if (intensity > max_brightness) {
> +		printk(KERN_INFO "Acer4736_bl: Invalid parameter. Maximum value is %d"
> +		, max_brightness);

Beginning a line with a comma is not at all common and
should be avoided.  printks need newline terminations,
and this would be better as pr_info.  Maybe:

		pr_info("Invalid parameter %u: Maximum allowed value: %u\n",
			intensity, max_brightness);

> +	printk(KERN_INFO "Loading Acer 4736 backlight driver\n");

	pr_info("Loading backlight driver\n");



