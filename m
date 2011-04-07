Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1DGJth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:49:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:46188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1DGJtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:49:36 -0400
Date: Thu, 7 Apr 2011 09:49:22 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        feng.tang@intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, feng.tang@intel.com, mingo@elte.hu
In-Reply-To: <1302140389-27603-1-git-send-email-feng.tang@intel.com>
References: <1302140389-27603-1-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] x86/mrst/vrtc: Fix boot crash in mrst_rtc_init()
Message-ID: <tip-09552b2696896dbb715be0caf91b23276f9139ba@git.kernel.org>
Git-Commit-ID: 09552b2696896dbb715be0caf91b23276f9139ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 09:49:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09552b2696896dbb715be0caf91b23276f9139ba
Gitweb:     http://git.kernel.org/tip/09552b2696896dbb715be0caf91b23276f9139ba
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Thu, 7 Apr 2011 09:39:49 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 7 Apr 2011 11:27:42 +0200

x86/mrst/vrtc: Fix boot crash in mrst_rtc_init()

The sfi_mrtc_array[] only gets initialized when the sfi mrtc
table is parsed, so the vrtc_paddr should be initalized after it
too.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1302140389-27603-1-git-send-email-feng.tang@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/mrst/vrtc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 04cf645..73d70d6 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -100,9 +100,11 @@ int vrtc_set_mmss(unsigned long nowtime)
 
 void __init mrst_rtc_init(void)
 {
-	unsigned long vrtc_paddr = sfi_mrtc_array[0].phys_addr;
+	unsigned long vrtc_paddr;
 
 	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
+
+	vrtc_paddr = sfi_mrtc_array[0].phys_addr;
 	if (!sfi_mrtc_num || !vrtc_paddr)
 		return;
 
