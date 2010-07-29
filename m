Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0G2N2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:28:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:58630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab0G2N2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:28:05 -0400
Date: Thu, 29 Jul 2010 13:27:45 GMT
From: tip-bot for Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, kaneshige.kenji@jp.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, tglx@linutronix.de,
        kaneshige.kenji@jp.fujitsu.com
In-Reply-To: <4C47DDCF.80300@jp.fujitsu.com>
References: <4C47DDCF.80300@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Ioremap: fix wrong physical address handling in PAT code
Message-ID: <tip-3709c857350976408953831f0cf89d19951394a1@git.kernel.org>
Git-Commit-ID: 3709c857350976408953831f0cf89d19951394a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Jul 2010 13:27:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3709c857350976408953831f0cf89d19951394a1
Gitweb:     http://git.kernel.org/tip/3709c857350976408953831f0cf89d19951394a1
Author:     Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
AuthorDate: Thu, 22 Jul 2010 14:57:35 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Jul 2010 15:26:11 +0200

x86: Ioremap: fix wrong physical address handling in PAT code

The following two commits fixed a problem that x86 ioremap() doesn't handle
physical address higher than 32-bit properly in X86_32 PAE mode.

 ffa71f33a820d1ab3f2fc5723819ac60fb76080b (x86, ioremap: Fix incorrect
 physical address handling in PAE mode)

 35be1b716a475717611b2dc04185e9d80b9cb693 (x86, ioremap: Fix normal
 ram range check)

But these fixes are not enough, since pat_pagerange_is_ram() in PAT code
also has a same problem. This patch fixes it.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
LKML-Reference: <4C47DDCF.80300@jp.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index acc15b2..03b48c8 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -158,7 +158,7 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 	return req_type;
 }
 
-static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
+static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
 {
 	int ram_page = 0, not_rampage = 0;
 	unsigned long page_nr;
