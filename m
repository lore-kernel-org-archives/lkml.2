Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab0EDOeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:34:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:25589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab0EDOe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AbpK82oBUACHvnSBahyGoLFvA2eNDn9o3zkj6x3ZnGUPBEeE3rYq3u9BILIYELwX+s
         06XS7pKptDjXkInplLuRf8N+gahbEif4xpG0xihW6w7du9vvRbALgHu8gG2+axajaBTv
         AEHeuZnoFPa3YuQrO59/sA4SHKNIulW0umrXg=
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: paulius.zaleckas@gmail.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: [PATCH] ARM: Gemini: fix compiler error in copypage-fa.c
Date: Tue,  4 May 2010 16:34:15 +0200
Message-Id: <1272983655-18408-1-git-send-email-ulli.kroll@googlemail.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compiler error in copypage-fs.c
missing struct vm_area_struct *vma in function
fa_copy_user_highpage

Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
---
 arch/arm/mm/copypage-fa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/copypage-fa.c b/arch/arm/mm/copypage-fa.c
index b2a6008..d2852e1 100644
--- a/arch/arm/mm/copypage-fa.c
+++ b/arch/arm/mm/copypage-fa.c
@@ -40,7 +40,7 @@ fa_copy_user_page(void *kto, const void *kfrom)
 }
 
 void fa_copy_user_highpage(struct page *to, struct page *from,
-	unsigned long vaddr)
+	unsigned long vaddr, struct vm_area_struct *vma)
 {
 	void *kto, *kfrom;
 
-- 
1.7.0.3

