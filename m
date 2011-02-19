Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab1BSPfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 10:35:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53356 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab1BSPfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 10:35:16 -0500
Date: Sat, 19 Feb 2011 15:34:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Make clocksource name const
Message-ID: <20110219153450.GI29493@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As nothing should be writing to the clocksource name string, make the
clocksource name pointer const.  Build-tested on ARM Versatile Express.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 include/linux/clocksource.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c37b21a..94c1f38 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -161,7 +161,7 @@ struct clocksource {
 	/*
 	 * First part of structure is read mostly
 	 */
-	char *name;
+	const char *name;
 	struct list_head list;
 	int rating;
 	cycle_t (*read)(struct clocksource *cs);
