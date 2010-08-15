Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0HOFaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:30:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47805 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0HOFaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=lLUrs8AS/2sFpouwnFHFLnbojacfbnj0VDra2/Izaio1sOCIgEVkjkRRgAYyKnEAby
         iJNPib/Phg/+N7cfmE+ULaXIdf0ne15Kl7Upn4kRYyPNAr/NQstz+1c9//1NBKQCSrNv
         pSkyQOnQxDAEWKKfkkcNNga/AMQwNlGSLp2m0=
MIME-Version: 1.0
Date: Sun, 15 Aug 2010 13:30:17 +0800
Message-ID: <AANLkTikHHv8j4BOgA36Q16Fn1bh5XMgtzf5LWgY8xNjE@mail.gmail.com>
Subject: [PATCH] mm: code improvement of check_stack_guard_page function
From: jovi zhang <bookjovi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7F5UTgr026833

little code improvement of check_stack_guard_page function.
this commit is on top of commit "mm: keep a guard page below a
grow-down stack segment" of linus.

diff --git a/mm/memory.c b/mm/memory.c
index 9b3b73f..643b112 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2768,13 +2768,15 @@ out_release:
Â */
static inline int check_stack_guard_page(struct vm_area_struct *vma,
unsigned long address)
{
- Â  Â  Â  address &= PAGE_MASK;
- Â  Â  Â  if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
- Â  Â  Â  Â  Â  Â  Â  address -= PAGE_SIZE;
- Â  Â  Â  Â  Â  Â  Â  if (find_vma(vma->vm_mm, address) != vma)
- Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return -ENOMEM;
-
- Â  Â  Â  Â  Â  Â  Â  expand_stack(vma, address);
+ Â  Â  Â  if (vma->vm_flags & VM_GROWSDOWN) {
+ Â  Â  Â  Â  Â  Â  Â  address &= PAGE_MASK;
+ Â  Â  Â  Â  Â  Â  Â  if(address == vma->vm_start) {
+ Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  address -= PAGE_SIZE;
+ Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  if (unlikely(find_vma(vma->vm_mm, address) != vma))
+ Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return -ENOMEM;
+
+ Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  expand_stack(vma, address);
+ Â  Â  Â  Â  Â  Â  Â  }
Â  Â  Â  Â }
Â  Â  Â  Â return 0;
}
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
