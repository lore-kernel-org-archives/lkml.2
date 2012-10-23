Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab2JWNwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:52:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:7299 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab2JWNwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:52:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237190988"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 03/26] pstore: add flush
Date: Tue, 23 Oct 2012 16:48:01 +0300
Message-Id: <1351000104-13015-4-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
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

