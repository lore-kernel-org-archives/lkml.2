Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab2HQIpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:45:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48569 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030986Ab2HQIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:44:48 -0400
From: Huacai Chen <chenhc@lemote.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH V6 11/15] drm: Handle io prot correctly for MIPS
Date: Fri, 17 Aug 2012 16:43:31 +0800
Message-Id: <1345193015-3024-12-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1345193015-3024-1-git-send-email-chenhc@lemote.com>
References: <1345193015-3024-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_vm.c          |    2 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 961ee08..3f06166 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -62,7 +62,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
 		tmp = pgprot_writecombine(tmp);
 	else
 		tmp = pgprot_noncached(tmp);
-#elif defined(__sparc__) || defined(__arm__)
+#elif defined(__sparc__) || defined(__arm__) || defined(__mips__)
 	tmp = pgprot_noncached(tmp);
 #endif
 	return tmp;
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index f8187ea..0df71ea 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -472,7 +472,7 @@ pgprot_t ttm_io_prot(uint32_t caching_flags, pgprot_t tmp)
 	else
 		tmp = pgprot_noncached(tmp);
 #endif
-#if defined(__sparc__)
+#if defined(__sparc__) || defined(__mips__)
 	if (!(caching_flags & TTM_PL_FLAG_CACHED))
 		tmp = pgprot_noncached(tmp);
 #endif
-- 
1.7.7.3

