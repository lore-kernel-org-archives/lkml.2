Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab0HOFPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:15:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33266 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0HOFPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=XlbOfUIRj+DvtbeYv0cgZ3xARbcHQTa10DHzY+n7TqlnivTaBup5oZDwRHt+53f5/5
         UaImISpDcDZzKcUztgRSdUizur6vZzKves0+RwiG1t3WJcu/MOQDWcOkBF/xbkpQvit8
         x4bjLHwvVZcM9dqOusbKkFFF+ftEOGz26IXH8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinfgXOzbqgrRY4oCGXFtKtEyJO_rvQeeEEeEZz7@mail.gmail.com>
References: <AANLkTinfgXOzbqgrRY4oCGXFtKtEyJO_rvQeeEEeEZz7@mail.gmail.com>
Date: Sun, 15 Aug 2010 13:15:17 +0800
Message-ID: <AANLkTimoD+-KzXVJhaKNZRvb=MkRgRUEQWnGNEwjvoRL@mail.gmail.com>
Subject: [PATCH] mm: code improvement of check_stack_guard_page
From: jovi zhang <bookjovi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7F5FR0U026784

little code improvement of check_stack_guard_page function.
this commit is on top of commit "mm: keep a guard page below a
grow-down stack segment" of linus.

diff --git a/mm/memory.c b/mm/memory.c
index 9b3b73f..643b112 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2768,13 +2768,15 @@ out_release:
  */
 static inline int check_stack_guard_page(struct vm_area_struct *vma,
unsigned long address)
 {
-       address &= PAGE_MASK;
-       if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
-               address -= PAGE_SIZE;
-               if (find_vma(vma->vm_mm, address) != vma)
-                       return -ENOMEM;
-
-               expand_stack(vma, address);
+       if (vma->vm_flags & VM_GROWSDOWN) {
+               address &= PAGE_MASK;
+               if(address == vma->vm_start) {
+                       address -= PAGE_SIZE;
+                       if (unlikely(find_vma(vma->vm_mm, address) != vma))
+                               return -ENOMEM;
+
+                       expand_stack(vma, address);
+               }
        }
        return 0;
 }
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
