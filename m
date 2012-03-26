Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab2CZQMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:12:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51911 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab2CZQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:12:42 -0400
Date: Mon, 26 Mar 2012 20:11:32 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: build failure after merge of the battery tree
Message-ID: <20120326161132.GA6430@lizard>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 01:56:09PM +1100, Stephen Rothwell wrote:
> Hi Anton,
> 
> After merging the battery tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/power/ab8500_btemp.c: In function 'ab8500_btemp_batctrl_volt_to_res':
> drivers/power/ab8500_btemp.c:142:2: error: implicit declaration of function 'is_ab8500_1p1_or_earlier' [-Werror=implicit-function-declaration]
> drivers/power/ab8500_btemp.c: In function 'ab8500_btemp_templow_handler':
> drivers/power/ab8500_btemp.c:619:2: error: implicit declaration of function 'is_ab8500_2p0_or_earlier' [-Werror=implicit-function-declaration]
> drivers/power/ab8500_charger.c: In function 'ab8500_charger_ac_en':
> drivers/power/ab8500_charger.c:1126:3: error: implicit declaration of function 'is_ab8500_1p1_or_earlier' [-Werror=implicit-function-declaration]
> drivers/power/ab8500_charger.c: In function 'ab8500_charger_remove':
> drivers/power/ab8500_charger.c:2519:2: error: implicit declaration of function 'usb_unregister_notifier' [-Werror=implicit-function-declaration]
> drivers/power/ab8500_charger.c:2520:2: error: implicit declaration of function 'usb_put_transceiver' [-Werror=implicit-function-declaration]
> drivers/power/ab8500_charger.c: In function 'ab8500_charger_probe':
> drivers/power/ab8500_charger.c:2688:2: error: implicit declaration of function 'usb_get_transceiver' [-Werror=implicit-function-declaration]
> drivers/power/ab8500_charger.c:2688:14: warning: assignment makes pointer from integer without a cast [enabled by default]
> drivers/power/ab8500_charger.c:2695:2: error: implicit declaration of function 'usb_register_notifier' [-Werror=implicit-function-declaration]
> 
> Caused by commits 89449ac8d6d2 ("ab8500-charger: AB8500 charger driver")
> and 20ac1aed6206 ("ab8500-btemp: AB8500 battery temperature driver").
> 
> I have used the battery tree form next-20120314 for today.

I pulled my current battery tree into next-20120326, and I can't reproduce
the issue (using allmodconfig on x86_64).

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
