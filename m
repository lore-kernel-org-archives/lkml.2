Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1FOIXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:23:31 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:59626 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1FOIX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:23:27 -0400
X-AuditID: b753bd60-a3c7dba0000050a4-b5-4df86a740895
X-AuditID: b753bd60-a3c7dba0000050a4-b5-4df86a740895
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH 3/3] [RFC] fs: print preferred name in procfs messages
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, greg@kroah.com,
        kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de,
        stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com,
        Nao Nishijima <nao.nishijima.xt@hitachi.com>
Date: Wed, 15 Jun 2011 17:16:42 +0900
Message-ID: <20110615081642.2237.53583.stgit@ltc233.sdl.hitachi.co.jp>
In-Reply-To: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make disk_name() return preferred name instead of disk_name
when preferred name is set. disk_name() is used in
/proc/{partitions, diskstats}. Therefore, those files show
preferred name.

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 fs/partitions/check.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index d545e97..4ffdcf4 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -125,11 +125,13 @@ static int (*check_part[])(struct parsed_partitions *) = {
 char *disk_name(struct gendisk *hd, int partno, char *buf)
 {
 	if (!partno)
-		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
+		snprintf(buf, BDEVNAME_SIZE, "%s", dev_name(disk_to_dev(hd)));
 	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
-		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, partno);
+		snprintf(buf, BDEVNAME_SIZE, "%sp%d", dev_name(disk_to_dev(hd)),
+			partno);
 	else
-		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, partno);
+		snprintf(buf, BDEVNAME_SIZE, "%s%d", dev_name(disk_to_dev(hd)),
+			partno);
 
 	return buf;
 }

