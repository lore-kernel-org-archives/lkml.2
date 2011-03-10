Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1CJX5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:57:25 -0500
Received: from kroah.org ([198.145.64.141]:46864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab1CJX5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:37 2011
Message-Id: <20110310235537.429280554@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Dave Jones <davej@redhat.com>
Subject: [patch 14/29] [CPUFREQ] pcc-cpufreq: dont load driver if get_freq fails during init.
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

commit 1f858ef2fbabdc5e645644010a31a40c32e397c9 upstream.

Return 0 on failure. This will cause the initialization of the driver
to fail and prevent the driver from loading if the BIOS cannot handle
the PCC interface command to "get frequency". Otherwise, the driver
will load and display a very high value like "4294967274" (which is
actually -EINVAL) for frequency:

# cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
4294967274

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
@@ -195,7 +195,7 @@ static unsigned int pcc_get_freq(unsigne
 cmd_incomplete:
 	iowrite16(0, &pcch_hdr->status);
 	spin_unlock(&pcc_lock);
-	return -EINVAL;
+	return 0;
 }
 
 static int pcc_cpufreq_target(struct cpufreq_policy *policy,


