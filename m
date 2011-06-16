Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab1FPHBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:55 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54607 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756103Ab1FPHBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:48 -0400
X-Sasl-enc: TrOM2VwjrrZLK+ClBDF+OZehmaXIXX6GWK8mKdYmug4j 1308207707
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:37 2011
Message-Id: <20110616000237.028780310@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Jones <davej@redhat.com>
Subject: [82/89] CPUFREQ: Remove cpufreq_stats sysfs entries on module unload.
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Jones <davej@redhat.com>

commit 13f067537f34456443f61c950cd6dc37d1d5f3ee upstream.

cpufreq_stats leaves behind its sysfs entries, which causes a panic
when something stumbled across them.
(Discovered by unloading cpufreq_stats while powertop was loaded).

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpufreq/cpufreq_stats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -388,6 +388,7 @@ static void __exit cpufreq_stats_exit(vo
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
 		cpufreq_stats_free_table(cpu);
+		cpufreq_stats_free_sysfs(cpu);
 	}
 }
 


