Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2LMOkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:40:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44602 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab2LMOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 130/241] x86, microcode, AMD: Add support for family 16h processors
Date: Thu, 13 Dec 2012 11:58:15 -0200
Message-Id: <1355407206-17100-131-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

commit 36c46ca4f322a7bf89aad5462a3a1f61713edce7 upstream.

Add valid patch size for family 16h processors.

[ hpa: promoting to urgent/stable since it is hw enabling and trivial ]

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Acked-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
Link: http://lkml.kernel.org/r/1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/microcode_amd.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 82746f9..5d8cf0d 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -97,6 +97,7 @@ static unsigned int verify_ucode_size(int cpu, u32 patch_size,
 #define F1XH_MPB_MAX_SIZE 2048
 #define F14H_MPB_MAX_SIZE 1824
 #define F15H_MPB_MAX_SIZE 4096
+#define F16H_MPB_MAX_SIZE 3458
 
 	switch (c->x86) {
 	case 0x14:
@@ -105,6 +106,9 @@ static unsigned int verify_ucode_size(int cpu, u32 patch_size,
 	case 0x15:
 		max_size = F15H_MPB_MAX_SIZE;
 		break;
+	case 0x16:
+		max_size = F16H_MPB_MAX_SIZE;
+		break;
 	default:
 		max_size = F1XH_MPB_MAX_SIZE;
 		break;
-- 
1.7.9.5

