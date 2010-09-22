Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0IVGJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 02:09:06 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:45481 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751868Ab0IVGJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 02:09:03 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 5OCCwU8VM1m1NxAHsZzWO4w5jC.uiTdmPDA3WUMX6gRcVen
 y1OcerUZZyYJUKXHTkQRvwpE6Bbn3Wi9Ua_Vvn7j4NOXU14BqOkZ9hmhIxDl
 MzTggFT_e7ouE7.1ij9wsrNrNFJUwlcAbg2VcX4Yg2Ln4SbgLtPm9MdRt4Xz
 fiDbKdPhlYbz6Og6IXwNWlZP6HP0sU_aeaVkg147Qpg.DKmcaWC.8HrD2gqY
 xpIWZJDdMyRpYahSMRZWsuOE9ntTkyYIUnANVko7QtIA2nK3Jo8IZyOpJ0ok
 .k8W8CIxA8Sj2tkuoe_UyUOfQN5M_h9wHasTiX9nkRtCQWEoH1AxFWFheboC
 L7q7tMbQ5USOVrV9XTA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm: Add XDWRITEREAD_10 passthrough support
Date: Tue, 21 Sep 2010 23:09:01 -0700
Message-Id: <1285135741-8371-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the simple check for TCM/pSCSI usage with XDWRITE_READ10
to follow commit ba3d8e3f13 and perform the BIDI-COMMAND passthrough.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e514ffc..6976f93 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5566,6 +5566,13 @@ static int transport_generic_cmd_sequencer(
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->transport_get_lba = &transport_lba_32;
+		passthrough = (TRANSPORT(dev)->transport_type ==
+				TRANSPORT_PLUGIN_PHBA_PDEV);
+		/*
+		 * Skip the remaining assignments for TCM/PSCSI passthrough
+		 */
+		if (passthrough)
+			break;
 		/*
 		 * Setup BIDI XOR callback to be run during transport_generic_complete_ok()
 		 */
-- 
1.5.6.5

