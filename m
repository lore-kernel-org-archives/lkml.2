Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965904Ab2EODEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:04:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:49423 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964920Ab2EOCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 063/179] Remove cpufreq_stats sysfs entries on module unload.
Date: Mon, 14 May 2012 22:12:39 -0400
Message-ID: <1337048075-6132-64-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 13f067537f34456443f61c950cd6dc37d1d5f3ee upstream.

cpufreq_stats leaves behind its sysfs entries, which causes a panic
when something stumbled across them.
(Discovered by unloading cpufreq_stats while powertop was loaded).

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/cpufreq/cpufreq_stats.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 4f1b8de..7c7a1e4 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -388,6 +388,7 @@ static void __exit cpufreq_stats_exit(void)
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
 		cpufreq_stats_free_table(cpu);
+		cpufreq_stats_free_sysfs(cpu);
 	}
 }
 
-- 
1.7.9.6

