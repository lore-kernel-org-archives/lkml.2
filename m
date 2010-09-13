Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0IMTsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:41 -0400
Received: from mail.perches.com ([173.55.12.10]:1908 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab0IMTsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:40 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Nohee Ko <noheek@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 19/25] drivers/staging: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:57 -0700
Message-Id: <64ddc1a6204581d06e98d2eaad516d6e49aee801.1284406639.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/util/bcmutils.c          |    2 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    2 +-
 drivers/staging/cxt1e1/ossiRelease.c               |    2 +-
 drivers/staging/go7007/go7007-driver.c             |    2 +-
 drivers/staging/msm/mdp.c                          |    2 +-
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    6 +++---
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 364f837..77ae71b 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -905,7 +905,7 @@ static int findmatch(char *string, char *name)
  */
 uint getgpiopin(char *vars, char *pin_name, uint def_pin)
 {
-	char name[] = "gpioXXXX";
+	char name[sizeof("gpioXXXX")];
 	char *val;
 	uint pin;
 
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index cfcbd9b..dd8b932 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -374,7 +374,7 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* Loop through all comedi devices specified on the command-line,
 	   building our device list */
 	for (i = 0; i < COMEDI_NDEVCONFOPTS && (!i || it->options[i]); ++i) {
-		char file[] = "/dev/comediXXXXXX";
+		char file[sizeof("/dev/comediXXXXXX")];
 		int minor = it->options[i];
 		struct comedi_device *d;
 		int sdev = -1, nchans, tmp;
diff --git a/drivers/staging/cxt1e1/ossiRelease.c b/drivers/staging/cxt1e1/ossiRelease.c
index a560298..b80d101 100644
--- a/drivers/staging/cxt1e1/ossiRelease.c
+++ b/drivers/staging/cxt1e1/ossiRelease.c
@@ -34,6 +34,6 @@
  */
 
 
-char pmcc4_OSSI_release[] = "$Release: PMCC4_3_1B,  Copyright (c) 2008 One Stop Systems$";
+static const char pmcc4_OSSI_release[] = "$Release: PMCC4_3_1B,  Copyright (c) 2008 One Stop Systems$";
 
 /***  End-of-File  ***/
diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index 372a7c6..32757f5 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -92,7 +92,7 @@ EXPORT_SYMBOL(go7007_read_addr);
 static int go7007_load_encoder(struct go7007 *go)
 {
 	const struct firmware *fw_entry;
-	char fw_name[] = "go7007fw.bin";
+	static const char fw_name[] = "go7007fw.bin";
 	void *bounce;
 	int fw_len, rv = 0;
 	u16 intr_val, intr_data;
diff --git a/drivers/staging/msm/mdp.c b/drivers/staging/msm/mdp.c
index 58cb404..e5b7add 100644
--- a/drivers/staging/msm/mdp.c
+++ b/drivers/staging/msm/mdp.c
@@ -704,7 +704,7 @@ static void mdp_drv_init(void)
 #ifdef MSM_FB_ENABLE_DBGFS
 	{
 		struct dentry *root;
-		char sub_name[] = "mdp";
+		static const char sub_name[] = "mdp";
 
 		root = msm_fb_get_debugfs_root();
 		if (root != NULL) {
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
index 08bfdb1..72bfcca 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -253,7 +253,7 @@ static int show_debug_level(char *page, char **start, off_t offset,
 static int store_debug_level(struct file *file, const char *buffer,
 			unsigned long count, void *data)
 {
-	char buf[] = "0x00000000";
+	char buf[sizeof("0x00000000")];
 	unsigned long len = min(sizeof(buf) - 1, (u32)count);
 	char *p = (char *)buf;
 	unsigned long val;
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
index 7455264..56c271d 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -256,7 +256,7 @@ static int show_debug_level(char *page, char **start, off_t offset,
 static int store_debug_level(struct file *file, const char *buffer,
 			     unsigned long count, void *data)
 {
-	char buf[] = "0x00000000";
+	char buf[sizeof("0x00000000")];
 	unsigned long len = min_t(unsigned long, sizeof(buf) - 1, count);
 	char *p = (char *)buf;
 	unsigned long val;
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 3581a55..1526a17 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -548,7 +548,7 @@ int dcd_get_objects(struct dcd_manager *hdcd_mgr,
 	struct cod_libraryobj *lib = NULL;
 	u32 ul_addr = 0;	/* Used by cod_get_section */
 	u32 ul_len = 0;		/* Used by cod_get_section */
-	char seps[] = ":, ";
+	static const char seps[] = ":, ";
 	char *token = NULL;
 	struct dsp_uuid dsp_uuid_obj;
 	s32 object_type;
@@ -1050,7 +1050,7 @@ static int get_attrs_from_buf(char *psz_buf, u32 ul_buf_size,
 				     struct dcd_genericobj *gen_obj)
 {
 	int status = 0;
-	char seps[] = ", ";
+	static const char seps[] = ", ";
 	char *psz_cur;
 	char *token;
 	s32 token_len = 0;
@@ -1419,7 +1419,7 @@ static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
 	u32 ul_addr = 0;	/* Used by cod_get_section */
 	u32 ul_len = 0;		/* Used by cod_get_section */
 	u32 dw_data_size = COD_MAXPATHLENGTH;
-	char seps[] = ", ";
+	static const char seps[] = ", ";
 	char *token = NULL;
 	bool get_uuids = (dep_lib_uuids != NULL);
 	u16 dep_libs = 0;
-- 
1.7.3.rc1

