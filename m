Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab2IKGIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:08:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49181 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2IKGIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:08:36 -0400
Message-ID: <504ED55F.9060701@gmail.com>
Date: Tue, 11 Sep 2012 16:08:31 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: samsung: use pr_* instead of printk
References: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com>
In-Reply-To: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/12 21:59, Jingoo Han wrote:
> This patch uses pr_* instead of printk.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com> --- 
> drivers/gpio/gpio-samsung.c |    6 +++--- 1 files changed, 3
> insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-samsung.c
> b/drivers/gpio/gpio-samsung.c index ba126cc..e38d990 100644 ---
> a/drivers/gpio/gpio-samsung.c +++ b/drivers/gpio/gpio-samsung.c @@
> -45,7 +45,7 @@ #ifndef DEBUG_GPIO #define gpio_dbg(x...) do { } while
> (0) #else -#define gpio_dbg(x...) printk(KERN_DEBUG x) +#define
> gpio_dbg(x...) pr_debug(x)

This is a functional change since pr_debug compiles away to nothing
unless DEBUG is defined, so now you need to define both DEBUG and
DEBUG_GPIO for this to print.

A better fix would be to just replace calls to gpio_dbg with pr_debug.

~Ryan
