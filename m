Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2AMOH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:07:56 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab2AMOHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:07:54 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        <stable@vger.kernel.org>
Subject: [PATCH] UBI: Handle empty string in verify_mkvol_req()
Date: Fri, 13 Jan 2012 15:07:40 +0100
Message-Id: <1326463660-17852-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it's possible to create a volume without a name.
E.g:
ubimkvol -n 32 -s 2MiB -t static /dev/ubi0 -N ""

After that vtbl_check() will always fail because it does not permit
empty strings.

Cc: <stable@vger.kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/cdev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 3320a50..ad76592 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -632,6 +632,9 @@ static int verify_mkvol_req(const struct ubi_device *ubi,
 	if (req->alignment != 1 && n)
 		goto bad;
 
+	if (!req->name[0] || !req->name_len)
+		goto bad;
+
 	if (req->name_len > UBI_VOL_NAME_MAX) {
 		err = -ENAMETOOLONG;
 		goto bad;
-- 
1.7.7.3

