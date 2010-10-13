Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0JMJbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:31:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51746 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0JMJbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:31:48 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/4] EDAC, MCE: Add F12h NB MCE decoder
Date: Wed, 13 Oct 2010 11:31:39 +0200
Message-Id: <1286962300-23385-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286962300-23385-1-git-send-email-bp@amd64.org>
References: <1286962300-23385-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F12h is completely covered by the generic path.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index fc3712f..6501392 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -427,7 +427,7 @@ out:
 	return ret;
 }
 
-static bool f14h_nb_mce(u16 ec, u8 xec)
+static bool nb_noop_mce(u16 ec, u8 xec)
 {
 	return false;
 }
@@ -641,13 +641,14 @@ static int __init mce_amd_init(void)
 	case 0x12:
 		fam_ops->dc_mce = f12h_dc_mce;
 		fam_ops->ic_mce = k8_ic_mce;
+		fam_ops->nb_mce = nb_noop_mce;
 		break;
 
 	case 0x14:
 		nb_err_cpumask  = 0x3;
 		fam_ops->dc_mce = f14h_dc_mce;
 		fam_ops->ic_mce = f14h_ic_mce;
-		fam_ops->nb_mce = f14h_nb_mce;
+		fam_ops->nb_mce = nb_noop_mce;
 		break;
 
 	default:
-- 
1.7.3.1.50.g1e633

