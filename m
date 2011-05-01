Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262Ab1EAQ7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:59:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:54820 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761251Ab1EAQ7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:59:31 -0400
Date: Sun, 1 May 2011 16:58:24 GMT
From: tip-bot for Boris Ostrovsky <ostr@amd64.org>
Message-ID: <tip-e20a2d205c05cef6b5783df339a7d54adeb50962@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, Boris.Ostrovsky@amd.com, hpa@zytor.com,
        mingo@redhat.com, jvpeetz@web.de, tglx@linutronix.de, ostr@amd64.org,
        mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, Boris.Ostrovsky@amd.com,
        linux-kernel@vger.kernel.org, jvpeetz@web.de, tglx@linutronix.de,
        ostr@amd64.org, mingo@elte.hu, borislav.petkov@amd.com
In-Reply-To: <1304113663-6586-1-git-send-email-ostr@amd64.org>
References: <1304113663-6586-1-git-send-email-ostr@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors
Git-Commit-ID: e20a2d205c05cef6b5783df339a7d54adeb50962
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 01 May 2011 16:58:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e20a2d205c05cef6b5783df339a7d54adeb50962
Gitweb:     http://git.kernel.org/tip/e20a2d205c05cef6b5783df339a7d54adeb50962
Author:     Boris Ostrovsky <ostr@amd64.org>
AuthorDate: Fri, 29 Apr 2011 17:47:43 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 1 May 2011 18:55:51 +0200

x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors

Older AMD K8 processors (Revisions A-E) are affected by erratum
400 (APIC timer interrupts don't occur in C states greater than
C1). This, for example, means that X86_FEATURE_ARAT flag should
not be set for these parts.

This addresses regression introduced by commit
b87cf80af3ba4b4c008b4face3c68d604e1715c6 ("x86, AMD: Set ARAT
feature on AMD processors") where the system may become
unresponsive until external interrupt (such as keyboard input)
occurs. This results, for example, in time not being reported
correctly, lack of progress on the system and other lockups.

Reported-by: Joerg-Volker Peetz <jvpeetz@web.de>
Tested-by: Joerg-Volker Peetz <jvpeetz@web.de>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/1304113663-6586-1-git-send-email-ostr@amd64.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3532d3b..bb9eb29 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -698,7 +698,7 @@ cpu_dev_register(amd_cpu_dev);
  */
 
 const int amd_erratum_400[] =
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0x0f, 0x4, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 EXPORT_SYMBOL_GPL(amd_erratum_400);
 
