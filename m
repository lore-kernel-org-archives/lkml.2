Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936085Ab2KATSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:18:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:22415 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935175Ab2KATRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="241495300"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/6] mei: mei_clear_list: kill file_temp
Date: Thu,  1 Nov 2012 21:17:16 +0200
Message-Id: <1351797438-26345-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
References: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

file_temp is used only once, so there is no any benefit of creating
a temporary variable

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index f69e085..d8221a5 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -103,18 +103,16 @@ static DEFINE_MUTEX(mei_mutex);
  * returns true if callback removed from the list, false otherwise
  */
 static bool mei_clear_list(struct mei_device *dev,
-		struct file *file, struct list_head *mei_cb_list)
+		const struct file *file, struct list_head *mei_cb_list)
 {
 	struct mei_cl_cb *cb_pos = NULL;
 	struct mei_cl_cb *cb_next = NULL;
-	struct file *file_temp;
 	bool removed = false;
 
 	/* list all list member */
 	list_for_each_entry_safe(cb_pos, cb_next, mei_cb_list, list) {
-		file_temp = (struct file *)cb_pos->file_object;
 		/* check if list member associated with a file */
-		if (file_temp == file) {
+		if (file == cb_pos->file_object) {
 			/* remove member from the list */
 			list_del(&cb_pos->list);
 			/* check if cb equal to current iamthif cb */
-- 
1.7.4.4

