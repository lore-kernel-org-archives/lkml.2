Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab2HVKWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:22:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2HVKWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:22:50 -0400
Date: Wed, 22 Aug 2012 03:21:52 -0700
From: tip-bot for Avi Kivity <avi@redhat.com>
Message-ID: <tip-cb09cad44f07044d9810f18f6f9a6a6f3771f979@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, tracek@redhat.com,
        hpa@zytor.com, mingo@kernel.org, anthony@codemonkey.ws,
        alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, tglx@linutronix.de,
        mjt@tls.msk.ru, hpa@linux.intel.com, avi@redhat.com,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, tracek@redhat.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        anthony@codemonkey.ws, alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, mjt@tls.msk.ru,
        borislav.petkov@amd.com, avi@redhat.com
In-Reply-To: <5034AE84.90708@redhat.com>
References: <5034AE84.90708@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/alternatives:
  Fix p6 nops on non-modular kernels
Git-Commit-ID: cb09cad44f07044d9810f18f6f9a6a6f3771f979
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 03:22:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb09cad44f07044d9810f18f6f9a6a6f3771f979
Gitweb:     http://git.kernel.org/tip/cb09cad44f07044d9810f18f6f9a6a6f3771f979
Author:     Avi Kivity <avi@redhat.com>
AuthorDate: Wed, 22 Aug 2012 13:03:48 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 22 Aug 2012 12:09:49 +0200

x86/alternatives: Fix p6 nops on non-modular kernels

Probably a leftover from the early days of self-patching, p6nops
are marked __initconst_or_module, which causes them to be
discarded in a non-modular kernel.  If something later triggers
patching, it will overwrite kernel code with garbage.

Reported-by: Tomas Racek <tracek@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org
Cc: Anthony Liguori <anthony@codemonkey.ws>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/5034AE84.90708@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index afb7ff7..ced4534 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -165,7 +165,7 @@ static const unsigned char * const k7_nops[ASM_NOP_MAX+2] =
 #endif
 
 #ifdef P6_NOP1
-static const unsigned char  __initconst_or_module p6nops[] =
+static const unsigned char p6nops[] =
 {
 	P6_NOP1,
 	P6_NOP2,
