Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0HaKY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 06:24:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60565 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab0HaKY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 06:24:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=IL2tbyCxOfdeGNU9DjYArUbUz92UhozGzLbTDxYZkWEbcr0L+99dXHsmkSGqTOZvsR
         LeOdXYR6qG9SGAmfoRfX9TOnPK5htLStM+1W7aeMl3u2TMOgHoTfV69wRQwdtKCoAy99
         6kikw0hnHO89GEGKPBd4cauqTTc6N8o3yPGTg=
Message-ID: <4c7cd856.cb71df0a.1986.ffffad0f@mx.google.com>
Date: Tue, 31 Aug 2010 13:24:19 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: ralf@linux-mips.org, wuzhangjin@gmail.com, linux-mips@linux-mips.org
Cc: alex@digriz.org.uk, manuel.lauss@googlemail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: Calculate VMLINUZ_LOAD_ADDRESS based on the length of
 vmlinux.bin
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix VMLINUZ_LOAD_ADDRESS calculation to be based on the length of vmlinux.bin,
the actual uncompressed kernel binary.

Previously it was based on the length of KBUILD_IMAGE (the unstripped ELF
vmlinux), which is bigger than vmlinux.bin.
As a result, vmlinuz was loaded into a memory address higher then actually
needed - a problem for small memory platforms.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index ed9bb70..5fd7f7a 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -59,7 +59,7 @@ $(obj)/piggy.o: $(obj)/dummy.o $(obj)/vmlinux.bin.z FORCE
 hostprogs-y := calc_vmlinuz_load_addr
 
 VMLINUZ_LOAD_ADDRESS = $(shell $(obj)/calc_vmlinuz_load_addr \
-		$(objtree)/$(KBUILD_IMAGE) $(VMLINUX_LOAD_ADDRESS))
+		$(obj)/vmlinux.bin $(VMLINUX_LOAD_ADDRESS))
 
 vmlinuzobjs-y += $(obj)/piggy.o
 
-- 
Shmulik Ladkani
