Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581Ab2J0WeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 18:34:23 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:35274 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498Ab2J0WeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 18:34:22 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>,
        Jordan Justen <jordan.l.justen@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] x86: remove dummy long from EFI stub
Date: Sat, 27 Oct 2012 20:34:15 -0200
Message-Id: <1351377255-21092-2-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2e064b1 (x86, efi: Fix issue of overlapping .reloc section for
EFI_STUB) removed a dummy reloc added by commit 291f363 (x86, efi: EFI
boot stub support), but forgot to remove the dummy long used by that
reloc.

Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 arch/x86/boot/header.S | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 2a01744..8c132a6 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -476,6 +476,3 @@ die:
 setup_corrupt:
 	.byte	7
 	.string	"No setup signature found...\n"
-
-	.data
-dummy:	.long	0
-- 
1.7.11.7

