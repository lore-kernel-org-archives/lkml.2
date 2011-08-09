Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1HIO3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:29:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:37349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab1HIO3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:29:18 -0400
Date: Tue, 9 Aug 2011 14:29:05 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Message-ID: <tip-05e33fc20ea5e493a2a1e7f1d04f43cdf89f83ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110805140900.GA6774@sgi.com>
References: <20110805140900.GA6774@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV: Remove UV delay in starting slave cpus
Git-Commit-ID: 05e33fc20ea5e493a2a1e7f1d04f43cdf89f83ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Aug 2011 14:29:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05e33fc20ea5e493a2a1e7f1d04f43cdf89f83ed
Gitweb:     http://git.kernel.org/tip/05e33fc20ea5e493a2a1e7f1d04f43cdf89f83ed
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Fri, 5 Aug 2011 09:09:00 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Aug 2011 23:48:34 +0200

x86, UV: Remove UV delay in starting slave cpus

Delete the 10 msec delay between the INIT and SIPI when starting
slave cpus. I can find no requirement for this delay. BIOS also
has similar code sequences without the delay.

Removing the delay reduces boot time by 40 sec. Every bit helps.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/20110805140900.GA6774@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index adc66c3..34b1859 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -207,7 +207,6 @@ static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_ri
 	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_INIT;
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
-	mdelay(10);
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
