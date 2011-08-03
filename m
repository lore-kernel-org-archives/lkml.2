Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1HCXpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:45:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab1HCXZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:25:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:45 2011
Message-Id: <20110803221245.842889945@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Chew <achew@nvidia.com>
Subject: [018/102] drivers/rtc/rtc-tegra.c: properly initialize spinlock
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

commit e57ee01750c4954fd0b5e3c6109cd4b870880eb9 upstream.

Using __SPIN_LOCK_UNLOCKED for a dynamically allocated lock is wrong and
breaks the build with PREEMPT_RT_FULL.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Andrew Chew <achew@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -343,7 +343,7 @@ static int __devinit tegra_rtc_probe(str
 
 	/* set context info. */
 	info->pdev = pdev;
-	info->tegra_rtc_lock = __SPIN_LOCK_UNLOCKED(info->tegra_rtc_lock);
+	spin_lock_init(&info->tegra_rtc_lock);
 
 	platform_set_drvdata(pdev, info);
 


