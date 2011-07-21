Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1GUVAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:00:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1GUU75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:59:57 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mikew@google.com, tony.luck@intel.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 3/9] pstore: Make "part" unsigned
Date: Thu, 21 Jul 2011 16:57:54 -0400
Message-Id: <1311281880-28041-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1311281880-28041-1-git-send-email-mjg@redhat.com>
References: <1311281880-28041-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll never have a negative part, so just make this an unsigned int.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/apei/erst.c |    8 ++++----
 fs/pstore/platform.c     |    3 ++-
 include/linux/pstore.h   |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 51cf7ba..2ca59dc 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -933,8 +933,8 @@ static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
 			   struct timespec *time, struct pstore_info *psi);
-static u64 erst_writer(enum pstore_type_id type, int part, size_t size,
-		       struct pstore_info *psi);
+static u64 erst_writer(enum pstore_type_id type, unsigned int part,
+		       size_t size, struct pstore_info *psi);
 static int erst_clearer(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
 
@@ -1040,8 +1040,8 @@ out:
 	return (rc < 0) ? rc : (len - sizeof(*rcd));
 }
 
-static u64 erst_writer(enum pstore_type_id type, int part, size_t size,
-		       struct pstore_info *psi)
+static u64 erst_writer(enum pstore_type_id type, unsigned int part,
+		       size_t size, struct pstore_info *psi)
 {
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
 					(erst_info.buf - sizeof(*rcd));
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 163bb40..49ff1de 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -67,7 +67,8 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	unsigned long	size, total = 0;
 	char		*dst, *why;
 	u64		id;
-	int		hsize, part = 1;
+	int		hsize;
+	unsigned int	part = 1;
 
 	if (reason < ARRAY_SIZE(reason_str))
 		why = reason_str[reason];
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 12be8f1..cc03bbf 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -39,7 +39,7 @@ struct pstore_info {
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
 			struct timespec *time, struct pstore_info *psi);
-	u64		(*write)(enum pstore_type_id type, int part,
+	u64		(*write)(enum pstore_type_id type, unsigned int part,
 			size_t size, struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
-- 
1.7.6

