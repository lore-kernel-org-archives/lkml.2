Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1CNLHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:07:11 -0400
Received: from nm4-vm1.bullet.mail.sp2.yahoo.com ([98.139.91.191]:41924 "HELO
	nm4-vm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753624Ab1CNLHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:07:05 -0400
X-Yahoo-Newman-Id: 380929.65368.bm@omp1024.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: e3v4rigVM1mAPGubMH0xduTJqYiTkh5WlD.lUh.wp9VhFa4
 6K.imbFj1rZARofPBX4TRspuF4AjiRfnea0at8rZyWKu2ETJkcBvEqIJRvaV
 183gB14p3WI7SdUZJKkGSIT4uLuKkYFygh6OXY8rKdXbWIj1EplvFXchBIkJ
 NoYYWWM1maNSJ1ZptnPsbZd.YhaW1P.lK3Oy3IS9opclcnyTOIKYieGC2x5a
 9_NwZU1msr.B5sheXDP7Hdj.rr9tpM4_DRRukfdSJTNufEcWurA7O61LKbxn
 fSFDiSe.VKW.Yq6H1odl.gvT.WvdYDHMElAzMLGq_3FVUNIqxKIv2hyk01MD
 Irb2ra5EdJdg8HcWOl2P0OuiuXjTnnYA3J_TzNENqW5u5iknFtBjRul0Ms1u
 KX9QQIeEmEiMwaWrM1tioYSkMhbtY6ONTUdT3gDSpf05NS6PRXPGVVtUCbMx
 l43UmycPCLVHkTLwpmu3GZDGf6YqJMVJ3k4JVt7eNVvyjP_c1o_kcau8SkW8
 uUlVEB_.QUE5wad0ZR6DaMBCpAEJjHwMGHfqbFJglxcxzBfKTSn4o05KLMlW
 .x1fULnlYcr1P0gfazWdkzeDFsj1UTVriC6ZipW1J0RVlbwDfHyToz2qM.5.
 6YRlM5Gg1TcUNek4uRmFJjEidzPo-
X-Yahoo-Newman-Property: ymail-5
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 08/21] target: Remove spurious double cast from structure macro accessors
Date: Mon, 14 Mar 2011 04:06:02 -0700
Message-Id: <1300100775-10012-9-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Reported-by: Fubo Chen <fubo.chen@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_base.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bc93b78..b3a62e4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -494,8 +494,8 @@ struct se_task {
 	struct list_head t_state_list;
 } ____cacheline_aligned;
 
-#define TASK_CMD(task)	((struct se_cmd *)task->task_se_cmd)
-#define TASK_DEV(task)	((struct se_device *)task->se_dev)
+#define TASK_CMD(task)	((task)->task_se_cmd)
+#define TASK_DEV(task)	((task)->se_dev)
 
 struct se_cmd {
 	/* SAM response code being sent to initiator */
@@ -551,8 +551,8 @@ struct se_cmd {
 	void (*transport_complete_callback)(struct se_cmd *);
 } ____cacheline_aligned;
 
-#define T_TASK(cmd)     ((struct se_transport_task *)(cmd->t_task))
-#define CMD_TFO(cmd) ((struct target_core_fabric_ops *)cmd->se_tfo)
+#define T_TASK(cmd)     ((cmd)->t_task)
+#define CMD_TFO(cmd)	((cmd)->se_tfo)
 
 struct se_tmr_req {
 	/* Task Management function to be preformed */
@@ -615,8 +615,8 @@ struct se_session {
 	struct list_head	sess_acl_list;
 } ____cacheline_aligned;
 
-#define SE_SESS(cmd)		((struct se_session *)(cmd)->se_sess)
-#define SE_NODE_ACL(sess)	((struct se_node_acl *)(sess)->se_node_acl)
+#define SE_SESS(cmd)		((cmd)->se_sess)
+#define SE_NODE_ACL(sess)	((sess)->se_node_acl)
 
 struct se_device;
 struct se_transform_info;
@@ -803,8 +803,8 @@ struct se_device {
 	struct list_head	g_se_dev_list;
 }  ____cacheline_aligned;
 
-#define SE_DEV(cmd)		((struct se_device *)(cmd)->se_lun->lun_se_dev)
-#define SU_DEV(dev)		((struct se_subsystem_dev *)(dev)->se_sub_dev)
+#define SE_DEV(cmd)		((cmd)->se_lun->lun_se_dev)
+#define SU_DEV(dev)		((dev)->se_sub_dev)
 #define DEV_ATTRIB(dev)		(&(dev)->se_sub_dev->se_dev_attrib)
 #define DEV_T10_WWN(dev)	(&(dev)->se_sub_dev->t10_wwn)
 
@@ -832,7 +832,7 @@ struct se_hba {
 	struct se_subsystem_api *transport;
 }  ____cacheline_aligned;
 
-#define SE_HBA(d)		((struct se_hba *)(d)->se_hba)
+#define SE_HBA(dev)		((dev)->se_hba)
 
 struct se_lun {
 	/* See transport_lun_status_table */
@@ -852,7 +852,7 @@ struct se_lun {
 	struct se_port	*lun_sep;
 } ____cacheline_aligned;
 
-#define SE_LUN(c)		((struct se_lun *)(c)->se_lun)
+#define SE_LUN(cmd)		((cmd)->se_lun)
 
 struct scsi_port_stats {
        u64     cmd_pdus;
@@ -919,7 +919,7 @@ struct se_portal_group {
 	struct config_group	tpg_param_group;
 } ____cacheline_aligned;
 
-#define TPG_TFO(se_tpg)	((struct target_core_fabric_ops *)(se_tpg)->se_tpg_tfo)
+#define TPG_TFO(se_tpg)	((se_tpg)->se_tpg_tfo)
 
 struct se_wwn {
 	struct target_fabric_configfs *wwn_tf;
-- 
1.7.4.1

