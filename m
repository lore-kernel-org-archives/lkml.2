Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1DMNhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:37:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42986 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab1DMNhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:37:15 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Russ Anderson <rja@sgi.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: [PATCH 1/3] x86, MCE: Do not taint when correctable errors
Date: Wed, 13 Apr 2011 15:36:48 +0200
Message-Id: <1302701810-2471-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <20110413132409.GB1900@gere.osrc.amd.com>
References: <20110413132409.GB1900@gere.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Correctable errors are considered something rather normal on modern
hardware these days. Even more importantly, correctable errors mean
exactly that - they've been corrected by the hardware - and there's no
need to taint the kernel since execution hasn't been compromised so far.

Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..68e2303 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -590,7 +590,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
 			mce_log(&m);
 			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
-			add_taint(TAINT_MACHINE_CHECK);
 		}
 
 		/*
-- 
1.7.4.rc2

