Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2LDOFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:05:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:14163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2LDOFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975405"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 08/15] mei: mei_me_client is not hw API move to mei_dev.h
Date: Tue,  4 Dec 2012 16:04:37 +0200
Message-Id: <1354629884-3202-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove struct mei_me_client from hw.h as it is not
part of of the hardware API. Also it doesn't have to
be packed
Add kdoc for this structure

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw.h      |    6 ------
 drivers/misc/mei/mei_dev.h |   13 +++++++++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index ba7d06c..6ebb369 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -230,11 +230,5 @@ struct hbm_flow_control {
 	u8 reserved[MEI_FC_MESSAGE_RESERVED_LENGTH];
 } __packed;
 
-struct mei_me_client {
-	struct mei_client_properties props;
-	u8 client_id;
-	u8 mei_flow_ctrl_creds;
-} __packed;
-
 
 #endif
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 37eb041..ab085d1 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -158,6 +158,19 @@ struct mei_message_data {
 	unsigned char *data;
 };
 
+/**
+ * struct mei_me_client - representation of me (fw) client
+ *
+ * @props  - client properties
+ * @client_id - me client id
+ * @mei_flow_ctrl_creds - flow control credits
+ */
+struct mei_me_client {
+	struct mei_client_properties props;
+	u8 client_id;
+	u8 mei_flow_ctrl_creds;
+};
+
 
 struct mei_cl;
 
-- 
1.7.4.4

