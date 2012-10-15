Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2JOLgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:36:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:6779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2JOLgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:36:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="156285250"
From: dragos.tatulea@intel.com
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com
Subject: [PATCH 1/8] pstore: add flags
Date: Mon, 15 Oct 2012 14:38:50 +0300
Message-Id: <1350301137-16912-2-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350301137-16912-1-git-send-email-dragos.tatulea@intel.com>
References: <1350301137-16912-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Let the back end tweak pstore behaviour.  Flags added are:

	PSTORE_NO_HEADINGS

		Omit pstore heading lines from dumped data

	PSTORE_MAX_KMSG_BYTES

		Default kmsg_bytes to ULONG_MAX

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
--
 fs/pstore/platform.c   |    9 ++++++++-
 include/linux/pstore.h |    4 ++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index a40da07..c4ea778 100644
-- a/fs/pstore/platform.c
++ b/fs/pstore/platform.c
@@ -128,7 +128,11 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		size_t len;
 
 		dst = psinfo->buf;
		hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount, part);
		if (psinfo->flags & PSTORE_NO_HEADINGS)
			hsize = 0;
		else
			hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount,
					part);
 		size = psinfo->bufsize - hsize;
 		dst += hsize;
 
@@ -237,6 +241,9 @@ int pstore_register(struct pstore_info *psi)
 		return -EINVAL;
 	}
 
	if (psinfo->flags & PSTORE_MAX_KMSG_BYTES)
		kmsg_bytes = ULONG_MAX;

 	if (pstore_is_mounted())
 		pstore_get_records(0);
 
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index ee3034a..55ab23f 100644
-- a/include/linux/pstore.h
++ b/include/linux/pstore.h
@@ -40,9 +40,13 @@ enum pstore_type_id {
 
 struct module;
 
#define PSTORE_NO_HEADINGS	BIT(0)
#define PSTORE_MAX_KMSG_BYTES	BIT(1)

 struct pstore_info {
 	struct module	*owner;
 	char		*name;
	unsigned int	flags;
 	spinlock_t	buf_lock;	/* serialize access to 'buf' */
 	char		*buf;
 	size_t		bufsize;
- 
1.7.9.5

