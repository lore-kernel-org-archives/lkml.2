Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab2LABzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 20:55:41 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36191 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2LABzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 20:55:39 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/6] f2fs: show error in case of invalid mount arguments
Date: Sat,  1 Dec 2012 10:55:32 +0900
Message-Id: <1354326932-6690-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

print the invalid argument/value from parse_options in case of
mount failure.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 4360600..c72e517 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -311,6 +311,8 @@ static int parse_options(struct f2fs_sb_info *sbi, char *options)
 			set_opt(sbi, DISABLE_EXT_IDENTIFY);
 			break;
 		default:
+			pr_err("Unrecognized mount option \"%s\" or missing value\n",
+					p);
 			return -EINVAL;
 		}
 	}
-- 
1.7.9.5

