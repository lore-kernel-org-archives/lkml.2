Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2CCBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 20:16:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43495 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab2CCBQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 20:16:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linkinjeon@gmail.com designates 10.68.238.227 as permitted sender) smtp.mail=linkinjeon@gmail.com; dkim=pass header.i=linkinjeon@gmail.com
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Ravishankar N <cyberax82@gmail.com>
Subject: [PATCH 2/2] fat: Fix bug in enforcing Long File Name length.
Date: Fri,  2 Mar 2012 20:16:45 -0500
Message-Id: <1330737405-7129-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Since '*outlen' is initialized to zero,it is currently possible to create a f ilename of length (FAT_LFN_LEN +1) when utf8 is not enabled.To enforce the FA T_LFN_LEN limit, we must perform one less iteration.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Ravishankar N <cyberax82@gmail.com>
---
 fs/fat/namei_vfat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index aae3b4e..98ae804 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -522,7 +522,7 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 		op = &outname[*outlen * sizeof(wchar_t)];
 	} else {
 		for (i = 0, ip = name, op = outname, *outlen = 0;
-			 i < len && *outlen <= FAT_LFN_LEN;
+			 i < len && *outlen < FAT_LFN_LEN;
 			 *outlen += 1) {
 			if (escape && (*ip == ':')) {
 				if (i > len - 5)
-- 
1.7.5.4

