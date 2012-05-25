Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab2EYJj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:39:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2EYJjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:39:25 -0400
Date: Fri, 25 May 2012 02:39:14 -0700
From: tip-bot for Magnus Damm <magnus.damm@gmail.com>
Message-ID: <tip-fc0830fe017d02b7b4995b5c402b484b65d9dfc6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        damm@opensource.se, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        damm@opensource.se, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20120509143950.27521.7949.sendpatchset@w520>
References: <20120509143950.27521.7949.sendpatchset@w520>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: em_sti: Add DT support
Git-Commit-ID: fc0830fe017d02b7b4995b5c402b484b65d9dfc6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 25 May 2012 02:39:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc0830fe017d02b7b4995b5c402b484b65d9dfc6
Gitweb:     http://git.kernel.org/tip/fc0830fe017d02b7b4995b5c402b484b65d9dfc6
Author:     Magnus Damm <magnus.damm@gmail.com>
AuthorDate: Wed, 9 May 2012 23:39:50 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 25 May 2012 11:32:06 +0200

clocksource: em_sti: Add DT support

Update the em-sti driver to support DT.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: arnd@arndb.de
Cc: horms@verge.net.au
Cc: johnstul@us.ibm.com
Cc: rjw@sisk.pl
Cc: lethal@linux-sh.org
Cc: gregkh@linuxfoundation.org
Cc: olof@lixom.net
Link: http://lkml.kernel.org/r/20120509143950.27521.7949.sendpatchset@w520
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/em_sti.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 719584a..372051d 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -384,11 +384,18 @@ static int __devexit em_sti_remove(struct platform_device *pdev)
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
+static const struct of_device_id em_sti_dt_ids[] __devinitconst = {
+	{ .compatible = "renesas,em-sti", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, em_sti_dt_ids);
+
 static struct platform_driver em_sti_device_driver = {
 	.probe		= em_sti_probe,
 	.remove		= __devexit_p(em_sti_remove),
 	.driver		= {
 		.name	= "em_sti",
+		.of_match_table = em_sti_dt_ids,
 	}
 };
 
