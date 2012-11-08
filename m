Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2KHNDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:03:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:60814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab2KHNDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244101989"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 03/26] pstore: add flush
Date: Thu,  8 Nov 2012 15:06:01 +0200
Message-Id: <1352379984-18381-4-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Let the back end know when writing has finished by adding a flush method.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 fs/pstore/platform.c   |    3 +++
 include/linux/pstore.h |    1 +
 2 files changed, 4 insertions(+)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index b9ab942..97ae8a9 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -114,6 +114,9 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 
 	why = get_reason_str(reason);
 
+	if (psinfo->flush)
+		psinfo->flush(psinfo);
+
 	if (in_nmi()) {
 		is_locked = spin_trylock(&psinfo->buf_lock);
 		if (!is_locked)
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 27f1995..3f93b4a 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -68,6 +68,7 @@ struct pstore_info {
 			struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
+	int		(*flush)(struct pstore_info *psi);
 	void		*data;
 };
 
-- 
1.7.9.5

