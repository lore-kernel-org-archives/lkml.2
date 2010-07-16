Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966026Ab0GPQOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:14:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43734 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965948Ab0GPQOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bUPws0UTJ2XOr/LdLp0FK+YN5/u1QgbbqVD6loXXSPdYWUmhOQgem1CwAkNp1APfQB
         oazDR9TIpXlhhCsVmPbeARMSV4NQk9EvOF6Iu7CK/Vk6Blzy1Eriytz1IqT70MPk2UGP
         4ZDuqQo7thTTlstA/FG38Trh+eS8QTXfY06Ls=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/15] staging: tidspbridge: check kmalloc() result
Date: Fri, 16 Jul 2010 20:14:11 +0400
Message-Id: <1279296851-24983-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kmalloc() fails then exit with -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/tidspbridge/pmgr/dspapi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 7597210..ba5d8c4 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -1407,6 +1407,8 @@ u32 strmwrap_allocate_buffer(union Trapped_Args *args, void *pr_ctxt)
 		return -EINVAL;
 
 	ap_buffer = kmalloc((num_bufs * sizeof(u8 *)), GFP_KERNEL);
+	if (ap_buffer == NULL)
+		return -ENOMEM;
 
 	status = strm_allocate_buffer(args->args_strm_allocatebuffer.hstream,
 				      args->args_strm_allocatebuffer.usize,
@@ -1446,6 +1448,8 @@ u32 strmwrap_free_buffer(union Trapped_Args *args, void *pr_ctxt)
 		return -EINVAL;
 
 	ap_buffer = kmalloc((num_bufs * sizeof(u8 *)), GFP_KERNEL);
+	if (ap_buffer == NULL)
+		return -ENOMEM;
 
 	CP_FM_USR(ap_buffer, args->args_strm_freebuffer.ap_buffer, status,
 		  num_bufs);
-- 
1.7.0.4

