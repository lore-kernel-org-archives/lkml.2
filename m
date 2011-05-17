Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1EQM4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:56:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36729 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab1EQM4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:56:05 -0400
From: Borislav Petkov <bp@amd64.org>
To: Nick Bowler <nbowler@elliptictech.com>,
        =?UTF-8?q?J=C3=B6rg-Volker=20Peetz?= <jvpeetz@web.de>
Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] Revert "x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors"
Date: Tue, 17 May 2011 14:55:18 +0200
Message-Id: <1305636919-31165-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1305636919-31165-1-git-send-email-bp@amd64.org>
References: <1305636919-31165-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This reverts commit e20a2d205c05cef6b5783df339a7d54adeb50962.

Moving the lower endpoint of the Erratum 400 check to accomodate earlier
K8 revisions (A-E) opens a can of worms which is simply not worth to fix
properly by tweaking the errata checking framework:

* missing IntPenging MSR on revisions < CG cause #GP:

http://marc.info/?l=linux-kernel&m=130541471818831

* makes earlier revisions use the LAPIC timer instead of the C1E idle
routine which switches to HPET, thus not waking up in deeper C-states:

http://lkml.org/lkml/2011/4/24/20

Therefore, leave the original boundary starting with K8-revF.
---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bb9eb29..3532d3b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -698,7 +698,7 @@ cpu_dev_register(amd_cpu_dev);
  */
 
 const int amd_erratum_400[] =
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0x0f, 0x4, 0x2, 0xff, 0xf),
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 EXPORT_SYMBOL_GPL(amd_erratum_400);
 
-- 
1.7.4.rc2

