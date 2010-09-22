Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0IVLUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:20:00 -0400
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:25204 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751029Ab0IVLT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:19:59 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: IcEDWgQVM1mrHbReORCWbiN4xDa0PLD.Fog_8WCJHtxdRvY
 C.st2YPAqhaRJvBSK_0CeKtJuF1qCnNdChkHR72_uMHE76tUNtWUBqRVtb8N
 _dRxEIM1_KZPw4wYeMy_Kq6pW.go9qlwF59oRWnE_SO6xd2AgHW6D8KU52M9
 JHIZlT21TZcFZH2FOQG2pFKGos2PqqXc54dmsETl6Rz4gxApYE0oxg8UXC2q
 oGbheBBE.6gZKsD73GubIPlrxYR7HBptoScZ1aU7yHnelcFaW7BT7k0yuo6_
 .7Hk.5tNY0_zYb2mEQIUp1EY9EjwbdoUAJUTqtfRWpYsQYCFB44E1t4bI8uR
 pmHlqfEhGegHlgUadghrL55QS7tJga1NLqAmCaccAvr4pMDFIa0V_GeHN9te
 l4yMIuJVkr0TyIIlephAe0bq3ThBUyxzhEd0iQpRyGtSXlr4I5HmSN7UXhwF
 CBPktfLadFH.K
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joel Becker <Joel.Becker@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 1/2] tcm: Fix NULL pointer dereference for target_fabric_port_attrs[]
Date: Wed, 22 Sep 2010 04:19:52 -0700
Message-Id: <1285154392-6360-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a NULL pointer dereference in target_fabric_port_attrs[]
callers when handling the MappedLUN + non existent struct se_lun config_group
case in commit 036866f50e2.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index c689463..5d1a81d 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -517,6 +517,9 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_gp(
 	struct se_lun *lun,
 	char *page)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -528,6 +531,9 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_gp(
 	const char *page,
 	size_t count)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -543,6 +549,9 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_offline(
 	struct se_lun *lun,
 	char *page)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -554,6 +563,9 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_offline(
 	const char *page,
 	size_t count)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -569,6 +581,9 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_status(
 	struct se_lun *lun,
 	char *page)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -580,6 +595,9 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_status(
 	const char *page,
 	size_t count)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -595,6 +613,9 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_write_md(
 	struct se_lun *lun,
 	char *page)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -606,6 +627,9 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_write_md(
 	const char *page,
 	size_t count)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
-- 
1.5.6.5

