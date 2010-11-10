Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0KJTDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:38 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49283 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab0KJTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:35 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 06/12] EDAC, MCE: Add an F15h NB MCE decoder
Date: Wed, 10 Nov 2010 20:02:15 +0100
Message-Id: <1289415741-15000-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

by (almost) reusing the F10h one since the signatures are the same.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 44e6cda..efbcb53 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -556,6 +556,15 @@ static bool f10h_nb_mce(u16 ec, u8 xec)
 		goto out;
 		break;
 
+	case 0x19:
+		if (boot_cpu_data.x86 == 0x15)
+			pr_cont("Compute Unit Data Error.\n");
+		else
+			ret = false;
+
+		goto out;
+		break;
+
 	case 0x1c ... 0x1f:
 		offset = 24;
 		break;
@@ -804,6 +813,7 @@ static int __init mce_amd_init(void)
 		xec_mask = 0x1f;
 		fam_ops->dc_mce = f15h_dc_mce;
 		fam_ops->ic_mce = f15h_ic_mce;
+		fam_ops->nb_mce = f10h_nb_mce;
 		break;
 
 	default:
-- 
1.7.3.1.50.g1e633

