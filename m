Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1G1FR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:17:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:51307 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab1G1FQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 06/11] linux/stop_machine.h: fix implicit use of smp.h for smp_processor_id
Date: Thu, 28 Jul 2011 01:16:13 -0400
Message-Id: <1311830178-30314-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will show up on MIPS when we fix all the implicit header presences
that are because of module.h being everywhere.

In file included from kernel/trace/ftrace.c:16:
include/linux/stop_machine.h: In function 'stop_one_cpu':
include/linux/stop_machine.h:50: error: implicit declaration of function 'smp_processor_id'
include/linux/stop_machine.h: In function 'stop_cpus':
include/linux/stop_machine.h:80: error: implicit declaration of function 'raw_smp_processor_id'

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/stop_machine.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 2d04ea9..c170edc 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -3,6 +3,7 @@
 
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/smp.h>
 #include <linux/list.h>
 #include <asm/system.h>
 
-- 
1.7.6

