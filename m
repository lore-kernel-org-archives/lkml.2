Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1BEOWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54987 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1BEOWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wpD7xsy6pkFB6mMDV8MNXDXDIXsCHDqupJ/6D9R4oJNIXhu183Vx64L610k/GVkymy
         OURZjfr0IZP85m4hsZgHRz0l98JLV+jFAqoQDm47yt9t0asmQglbbbCreQhX6gPQ9drM
         7OYwgD8d88eW1Mf0+/mesDjcS2wJj8afEp4BE=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 39/52] kstrtox: convert drivers/target/
Date: Sat,  5 Feb 2011 16:20:42 +0200
Message-Id: <1296915654-7458-39-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/target/target_core_alua.c            |   28 ++++----
 drivers/target/target_core_configfs.c        |  102 ++++++++------------------
 drivers/target/target_core_fabric_configfs.c |   13 ++--
 drivers/target/target_core_file.c            |    7 +-
 4 files changed, 53 insertions(+), 97 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 2c5fcfe..27096da8 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1714,10 +1714,10 @@ ssize_t core_alua_store_access_type(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to extract alua_access_type\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1) && (tmp != 2) && (tmp != 3)) {
 		printk(KERN_ERR "Illegal value for alua_access_type:"
@@ -1752,10 +1752,10 @@ ssize_t core_alua_store_nonop_delay_msecs(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to extract nonop_delay_msecs\n");
-		return -EINVAL;
+		return ret;
 	}
 	if (tmp > ALUA_MAX_NONOP_DELAY_MSECS) {
 		printk(KERN_ERR "Passed nonop_delay_msecs: %lu, exceeds"
@@ -1783,10 +1783,10 @@ ssize_t core_alua_store_trans_delay_msecs(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to extract trans_delay_msecs\n");
-		return -EINVAL;
+		return ret;
 	}
 	if (tmp > ALUA_MAX_TRANS_DELAY_MSECS) {
 		printk(KERN_ERR "Passed trans_delay_msecs: %lu, exceeds"
@@ -1814,10 +1814,10 @@ ssize_t core_alua_store_preferred_bit(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to extract preferred ALUA value\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
 		printk(KERN_ERR "Illegal value for preferred ALUA: %lu\n", tmp);
@@ -1849,10 +1849,10 @@ ssize_t core_alua_store_offline_bit(
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to extract alua_tg_pt_offline value\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
 		printk(KERN_ERR "Illegal value for alua_tg_pt_offline: %lu\n",
@@ -1888,10 +1888,10 @@ ssize_t core_alua_store_secondary_status(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to extract alua_tg_pt_status\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != ALUA_STATUS_NONE) &&
 	    (tmp != ALUA_STATUS_ALTERED_BY_EXPLICT_STPG) &&
@@ -1921,10 +1921,10 @@ ssize_t core_alua_store_secondary_write_metadata(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to extract alua_tg_pt_write_md\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
 		printk(KERN_ERR "Illegal value for alua_tg_pt_write_md:"
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2764510..c659a7c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -649,23 +649,19 @@ static ssize_t target_core_dev_store_attr_##_name(			\
 {									\
 	struct se_device *dev;						\
 	struct se_subsystem_dev *se_dev = da->da_sub_dev;			\
-	unsigned long val;						\
+	u32 val;							\
 	int ret;							\
 									\
+	ret = kstrtou32(page, 0, &val);					\
+	if (ret < 0)							\
+		return ret;						\
 	spin_lock(&se_dev->se_dev_lock);				\
 	dev = se_dev->se_dev_ptr;					\
 	if (!(dev)) {							\
 		spin_unlock(&se_dev->se_dev_lock);			\
 		return -ENODEV;						\
 	}								\
-	ret = strict_strtoul(page, 0, &val);				\
-	if (ret < 0) {							\
-		spin_unlock(&se_dev->se_dev_lock);                      \
-		printk(KERN_ERR "strict_strtoul() failed with"		\
-			" ret: %d\n", ret);				\
-		return -EINVAL;						\
-	}								\
-	ret = se_dev_set_##_name(dev, (u32)val);			\
+	ret = se_dev_set_##_name(dev, val);				\
 	spin_unlock(&se_dev->se_dev_lock);				\
 									\
 	return (!ret) ? count : -EINVAL;				\
@@ -1456,7 +1452,6 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 	unsigned char *isid = NULL;
 	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	unsigned long long tmp_ll;
 	u64 sa_res_key = 0;
 	u32 mapped_lun = 0, target_lun = 0;
 	int ret = -1, res_holder = 0, all_tg_pt = 0, arg, token;
@@ -1512,13 +1507,9 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			break;
 		case Opt_sa_res_key:
 			arg_p = match_strdup(&args[0]);
-			ret = strict_strtoull(arg_p, 0, &tmp_ll);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoull() failed for"
-					" sa_res_key=\n");
+			ret = kstrtou64(arg_p, 0, &sa_res_key);
+			if (ret < 0)
 				goto out;
-			}
-			sa_res_key = (u64)tmp_ll;
 			break;
 		/*
 		 * PR APTPL Metadata for Reservation
@@ -2061,22 +2052,14 @@ static ssize_t target_core_alua_lu_gp_store_attr_lu_gp_id(
 	size_t count)
 {
 	struct config_group *alua_lu_gp_cg = &lu_gp->lu_gp_group;
-	unsigned long lu_gp_id;
+	u16 lu_gp_id;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &lu_gp_id);
-	if (ret < 0) {
-		printk(KERN_ERR "strict_strtoul() returned %d for"
-			" lu_gp_id\n", ret);
-		return -EINVAL;
-	}
-	if (lu_gp_id > 0x0000ffff) {
-		printk(KERN_ERR "ALUA lu_gp_id: %lu exceeds maximum:"
-			" 0x0000ffff\n", lu_gp_id);
-		return -EINVAL;
-	}
+	ret = kstrtou16(page, 0, &lu_gp_id);
+	if (ret < 0)
+		return ret;
 
-	ret = core_alua_set_lu_gp_id(lu_gp, (u16)lu_gp_id);
+	ret = core_alua_set_lu_gp_id(lu_gp, lu_gp_id);
 	if (ret < 0)
 		return -EINVAL;
 
@@ -2242,7 +2225,6 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 	size_t count)
 {
 	struct se_subsystem_dev *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
-	unsigned long tmp;
 	int new_state, ret;
 
 	if (!(tg_pt_gp->tg_pt_gp_valid_id)) {
@@ -2251,13 +2233,9 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 		return -EINVAL;
 	}
 
-	ret = strict_strtoul(page, 0, &tmp);
-	if (ret < 0) {
-		printk("Unable to extract new ALUA access state from"
-				" %s\n", page);
-		return -EINVAL;
-	}
-	new_state = (int)tmp;
+	ret = kstrtoint(page, 0, &new_state);
+	if (ret < 0)
+		return ret;
 
 	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICT_ALUA)) {
 		printk(KERN_ERR "Unable to process implict configfs ALUA"
@@ -2288,7 +2266,6 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 	const char *page,
 	size_t count)
 {
-	unsigned long tmp;
 	int new_status, ret;
 
 	if (!(tg_pt_gp->tg_pt_gp_valid_id)) {
@@ -2298,13 +2275,9 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 		return -EINVAL;
 	}
 
-	ret = strict_strtoul(page, 0, &tmp);
-	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract new ALUA access status"
-				" from %s\n", page);
-		return -EINVAL;
-	}
-	new_status = (int)tmp;
+	ret = kstrtoint(page, 0, &new_status);
+	if (ret < 0)
+		return ret;
 
 	if ((new_status != ALUA_STATUS_NONE) &&
 	    (new_status != ALUA_STATUS_ALTERED_BY_EXPLICT_STPG) &&
@@ -2358,7 +2331,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_write_metadata(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to extract alua_write_metadata\n");
 		return -EINVAL;
@@ -2459,22 +2432,14 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_tg_pt_gp_id(
 	size_t count)
 {
 	struct config_group *alua_tg_pt_gp_cg = &tg_pt_gp->tg_pt_gp_group;
-	unsigned long tg_pt_gp_id;
+	u16 tg_pt_gp_id;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tg_pt_gp_id);
-	if (ret < 0) {
-		printk(KERN_ERR "strict_strtoul() returned %d for"
-			" tg_pt_gp_id\n", ret);
-		return -EINVAL;
-	}
-	if (tg_pt_gp_id > 0x0000ffff) {
-		printk(KERN_ERR "ALUA tg_pt_gp_id: %lu exceeds maximum:"
-			" 0x0000ffff\n", tg_pt_gp_id);
-		return -EINVAL;
-	}
+	ret = kstrtou16(page, 0, &tg_pt_gp_id);
+	if (ret < 0)
+		return ret;
 
-	ret = core_alua_set_tg_pt_gp_id(tg_pt_gp, (u16)tg_pt_gp_id);
+	ret = core_alua_set_tg_pt_gp_id(tg_pt_gp, tg_pt_gp_id);
 	if (ret < 0)
 		return -EINVAL;
 
@@ -2885,11 +2850,9 @@ static ssize_t target_core_hba_store_attr_hba_mode(struct se_hba *hba,
 	if (transport->pmode_enable_hba == NULL)
 		return -EINVAL;
 
-	ret = strict_strtoul(page, 0, &mode_flag);
-	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract hba mode flag: %d\n", ret);
-		return -EINVAL;
-	}
+	ret = kstrtoul(page, 0, &mode_flag);
+	if (ret < 0)
+		return ret;
 
 	spin_lock(&hba->device_lock);
 	if (!(list_empty(&hba->hba_dev_list))) {
@@ -2939,7 +2902,7 @@ static struct config_group *target_core_call_addhbatotarget(
 	char *se_plugin_str, *str, *str2;
 	struct se_hba *hba;
 	char buf[TARGET_CORE_NAME_MAX_LEN];
-	unsigned long plugin_dep_id = 0;
+	u32 plugin_dep_id;
 	int ret;
 
 	memset(buf, 0, TARGET_CORE_NAME_MAX_LEN);
@@ -2971,12 +2934,9 @@ static struct config_group *target_core_call_addhbatotarget(
 		str++; /* Skip to start of plugin dependent ID */
 	}
 
-	ret = strict_strtoul(str, 0, &plugin_dep_id);
-	if (ret < 0) {
-		printk(KERN_ERR "strict_strtoul() returned %d for"
-				" plugin_dep_id\n", ret);
-		return ERR_PTR(-EINVAL);
-	}
+	ret = kstrtou32(str, 0, &plugin_dep_id);
+	if (ret < 0)
+		return ERR_PTR(ret);
 	/*
 	 * Load up TCM subsystem plugins if they have not already been loaded.
 	 */
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 32b148d..5c6c43c 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -190,7 +190,7 @@ static ssize_t target_fabric_mappedlun_store_write_protect(
 	struct se_portal_group *se_tpg = se_nacl->se_tpg;
 	unsigned long op;
 
-	if (strict_strtoul(page, 0, &op))
+	if (kstrtoul(page, 0, &op))
 		return -EINVAL;
 
 	if ((op != 1) && (op != 0))
@@ -285,7 +285,7 @@ static struct config_group *target_fabric_make_mappedlun(
 	struct se_lun_acl *lacl;
 	struct config_item *acl_ci;
 	char *buf;
-	unsigned long mapped_lun;
+	unsigned int mapped_lun;
 	int ret = 0;
 
 	acl_ci = &group->cg_item;
@@ -313,10 +313,9 @@ static struct config_group *target_fabric_make_mappedlun(
 	 * Determine the Mapped LUN value.  This is what the SCSI Initiator
 	 * Port will actually see.
 	 */
-	if (strict_strtoul(buf + 4, 0, &mapped_lun) || mapped_lun > UINT_MAX) {
-		ret = -EINVAL;
+	ret = kstrtouint(buf + 4, 0, &mapped_lun);
+	if (ret < 0)
 		goto out;
-	}
 
 	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, mapped_lun,
 			config_item_name(acl_ci), &ret);
@@ -746,14 +745,14 @@ static struct config_group *target_fabric_make_lun(
 	struct se_portal_group *se_tpg = container_of(group,
 			struct se_portal_group, tpg_lun_group);
 	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
-	unsigned long unpacked_lun;
+	u32 unpacked_lun;
 
 	if (strstr(name, "lun_") != name) {
 		printk(KERN_ERR "Unable to locate \'_\" in"
 				" \"lun_$LUN_NUMBER\"\n");
 		return ERR_PTR(-EINVAL);
 	}
-	if (strict_strtoul(name + 4, 0, &unpacked_lun) || unpacked_lun > UINT_MAX)
+	if (kstrtou32(name + 4, 0, &unpacked_lun))
 		return ERR_PTR(-EINVAL);
 
 	lun = core_get_lun_from_tpg(se_tpg, unpacked_lun);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 0aaca88..7203eb1 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -545,12 +545,9 @@ static ssize_t fd_set_configfs_dev_params(
 			break;
 		case Opt_fd_dev_size:
 			arg_p = match_strdup(&args[0]);
-			ret = strict_strtoull(arg_p, 0, &fd_dev->fd_dev_size);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoull() failed for"
-						" fd_dev_size=\n");
+			ret = kstrtoull(arg_p, 0, &fd_dev->fd_dev_size);
+			if (ret < 0)
 				goto out;
-			}
 			printk(KERN_INFO "FILEIO: Referencing Size: %llu"
 					" bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
-- 
1.7.3.4

