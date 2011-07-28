Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1G1V35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 17:29:57 -0400
Received: from mail.perches.com ([173.55.12.10]:4354 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab1G1V3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 17:29:55 -0400
Subject: Re: [PATCH 1/9] watchdog: WatchDog Timer Driver Core - Add basic
 framework
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <1311797800-2706-1-git-send-email-wim@iguana.be>
References: <20110727201537.GA13819@infomag.iguana.be>
	 <1311797800-2706-1-git-send-email-wim@iguana.be>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 14:29:53 -0700
Message-ID: <1311888593.10042.36.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 20:16 +0000, Wim Van Sebroeck wrote:
> The WatchDog Timer Driver Core is a framework
> that contains the common code for all watchdog-driver's.
> It also introduces a watchdog device structure and the
> operations that go with it.
> 
> This is the introduction of this framework. This part
> supports the minimal watchdog userspace API (or with
> other words: the functionality to use /dev/watchdog's
> open, release and write functionality as defined in
> the simplest watchdog API). Extra functionality will
> follow in the next set of patches.

Perhaps add some logging helpers to the .h?

#define wdd_emerg(wd, fmt, ...)					\
	pr_emerg("%s: " fmt, (wd)->info->identity, ##__VA_ARGS__)
#define wdd_crit(wd, fmt, ...)					\
	pr_crit("%s: " fmt, (wd)->info->identity, ##__VA_ARGS__)
#define wdd_alert(wd, fmt, ...)					\
	pr_alert("%s: " fmt, (wd)->info->identity, ##__VA_ARGS__)
#define wdd_err(wd, fmt, ...)					\
	pr_err("%s: " fmt, (wd)->info->identity, ##__VA_ARGS__)
#define wdd_notice(wd, fmt, ...)				\
	pr_notice("%s: " fmt, (wd)->info->identity, ##__VA_ARGS__)
#define wdd_warn(wd, fmt, ...)					\
	pr_warn("%s: " fmt, (wd)->info->identity, ##__VA_ARGS__)
#define wdd_info(wd, fmt, ...)					\
	pr_info("%s: " fmt, (wd)->info->identity, ##__VA_ARGS__)
#define wdd_dbg(wd, fmt, ...)					\
	pr_debug("%s: " fmt, (wd)->info->identity, ##__VA_ARGS__)

> +	err = misc_register(&watchdog_miscdev);
> +	if (err != 0) {
> +		pr_err("%s: cannot register miscdev on minor=%d (err=%d).\n",
> +			watchdog->info->identity, WATCHDOG_MINOR, err);

		wdd_err(watchdog, "cannot register watchdog on minor %d, err: %d\n",
			WATCHDOG_MINOR, err);

etc...

