Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab1DYO2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:28:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36723 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab1DYO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=JN3VgWtHldlC6LWBbA2MWePL+BQqLY6MtjsKHRlBj08uuievGesZwHPzoEpIf8wUJI
         AOm2p8MzhEUA1w4A3Adt6jLrQAZyCht7QiNjgNjyOZTwdI0GSzVV+Xnd/qVMI4oS+Fnf
         kZAbdgFTvrigeEHk5fWHtDJr0r/b1c+o9RMKM=
Date: Mon, 25 Apr 2011 10:28:50 -0400 (EDT)
From: Anders Kaseorg <andersk@ksplice.com>
X-X-Sender: andersk@dr-wily.mit.edu
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, vdso: SHN_LORESERVE is an inclusive lower bound
Message-ID: <alpine.DEB.2.02.1104251020170.26664@dr-wily.mit.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test for >= SHN_LORESERVE instead of > SHN_LORESERVE.

Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
---
 arch/x86/vdso/vdso32-setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 468d591..226bfad 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -88,7 +88,7 @@ static __init void reloc_symtab(Elf32_Ehdr *ehdr,
 		    sym->st_shndx == SHN_ABS)
 			continue;  /* skip */
 
-		if (sym->st_shndx > SHN_LORESERVE) {
+		if (sym->st_shndx >= SHN_LORESERVE) {
 			printk(KERN_INFO "VDSO: unexpected st_shndx %x\n",
 			       sym->st_shndx);
 			continue;
-- 
1.7.5.rc3

