Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2A2WFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 17:05:09 -0500
Received: from smtp-2.sys.kth.se ([130.237.32.160]:44050 "EHLO
	smtp-2.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2A2WFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 17:05:07 -0500
X-KTH-Auth: niso [89.253.77.162]
X-KTH-mail-from: niso@kth.se
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
To: jj@chaosbits.net
Cc: mchehab@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
Subject: [PATCHv3] i7core_edac: fix erroneous size of static array
Date: Sun, 29 Jan 2012 23:04:32 +0100
Message-Id: <1327874672-19222-1-git-send-email-niso@kth.se>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <alpine.LNX.2.00.1201290300100.20079@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201290300100.20079@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove size from lookup arrays and mark them as const.

Signed-off-by: Niklas Söderlund <niso@kth.se>
---
 drivers/edac/i7core_edac.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 70ad892..f50acfb 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -417,21 +417,21 @@ static inline int numdimms(u32 dimms)
 
 static inline int numrank(u32 rank)
 {
-	static int ranks[4] = { 1, 2, 4, -EINVAL };
+	static const int ranks[] = { 1, 2, 4, -EINVAL };
 
 	return ranks[rank & 0x3];
 }
 
 static inline int numbank(u32 bank)
 {
-	static int banks[4] = { 4, 8, 16, -EINVAL };
+	static const int banks[] = { 4, 8, 16, -EINVAL };
 
 	return banks[bank & 0x3];
 }
 
 static inline int numrow(u32 row)
 {
-	static int rows[8] = {
+	static const int rows[] = {
 		1 << 12, 1 << 13, 1 << 14, 1 << 15,
 		1 << 16, -EINVAL, -EINVAL, -EINVAL,
 	};
@@ -441,7 +441,7 @@ static inline int numrow(u32 row)
 
 static inline int numcol(u32 col)
 {
-	static int cols[8] = {
+	static const int cols[] = {
 		1 << 10, 1 << 11, 1 << 12, -EINVAL,
 	};
 	return cols[col & 0x3];
-- 
1.7.8.4

