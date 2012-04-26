Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2DZML5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:11:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43941 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab2DZMLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:11:49 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/1] ntp: advertise correct TAI offset during leap second
Date: Thu, 26 Apr 2012 14:11:32 +0200
Message-Id: <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1335442155.git.richardcochran@gmail.com>
References: <cover.1335442155.git.richardcochran@gmail.com>
In-Reply-To: <cover.1335442155.git.richardcochran@gmail.com>
References: <cover.1335442155.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When repeating a UTC time value during a leap second (when the UTC
time should be 23:59:60), the TAI timescale should not stop. The kernel
NTP code increments the TAI offset one second too late. This patch fixes
the issue by incrementing the offset during the leap second itself.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 kernel/time/ntp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f03fd83..e8c8671 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -412,6 +412,7 @@ int second_overflow(unsigned long secs)
 		if (secs % 86400 == 0) {
 			leap = -1;
 			time_state = TIME_OOP;
+			time_tai++;
 			printk(KERN_NOTICE
 				"Clock: inserting leap second 23:59:60 UTC\n");
 		}
@@ -426,7 +427,6 @@ int second_overflow(unsigned long secs)
 		}
 		break;
 	case TIME_OOP:
-		time_tai++;
 		time_state = TIME_WAIT;
 		break;
 
-- 
1.7.2.5

