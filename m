Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1FHJNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:13:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48318 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1FHJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:13:17 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-34-4def3d2b1183
Subject: [PATCH] printk: do not handle non-sleepable notification in
 console_cpu_notify
From: mhban <mhban@samsung.com>
Reply-to: mhban@samsung.com
To: cernekee@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-type: text/plain; charset=UTF-8
Organization: SAMSUNG
Date: Wed, 08 Jun 2011 18:13:15 +0900
Message-id: <1307524395.6891.3.camel@puffmine-laptop>
MIME-version: 1.0
X-Mailer: Evolution 2.28.3
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2011 09:12:43.0968 (UTC)
 FILETIME=[39BD2C00:01CC25BC]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- CPU_DYING should not be handled in sleepable context

Signed-off-by: Minho Ban <mhban@samsung.com>
---
 kernel/printk.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..79075a0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1146,7 +1146,6 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DEAD:
-	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:
 		console_lock();
-- 
1.7.0.4


