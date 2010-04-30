Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab0D3SJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:09:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64759 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab0D3RbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:31:25 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 09/10] drivers: wireless: use new hex_to_bin() method
Date: Fri, 30 Apr 2010 12:34:08 +0300
Message-Id: <e1305499edede753c119de13fb1536387cb73532.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <ce5ee38b2d01568cd56ffc9598d7ceaa24738e65.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <c1ca828fb308042aa32428b345abcb43ccb02c39.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <2eb558b7b0b20dfea0b61223db6146cb8fdbe52d.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <7cd86c01ad4a376fb8a48ffe307ce7c0510cecc0.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d6886a8b94bf8726d7bde807b3ca19f65739ce4d.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <ce5ee38b2d01568cd56ffc9598d7ceaa24738e65.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:07.0536 (UTC) FILETIME=[47EB1B00:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using own implementation involve hex_to_bin() function.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/wireless/airo.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index dc5018a..1b9d408 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5151,13 +5151,6 @@ static void proc_SSID_on_close(struct inode *inode, struct file *file)
 	enable_MAC(ai, 1);
 }
 
-static inline u8 hexVal(char c) {
-	if (c>='0' && c<='9') return c -= '0';
-	if (c>='a' && c<='f') return c -= 'a'-10;
-	if (c>='A' && c<='F') return c -= 'A'-10;
-	return 0;
-}
-
 static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 	struct proc_data *data = (struct proc_data *)file->private_data;
 	struct proc_dir_entry *dp = PDE(inode);
@@ -5177,11 +5170,11 @@ static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 			switch(j%3) {
 			case 0:
 				APList_rid.ap[i][j/3]=
-					hexVal(data->wbuffer[j+i*6*3])<<4;
+					hex_to_bin(data->wbuffer[j+i*6*3])<<4;
 				break;
 			case 1:
 				APList_rid.ap[i][j/3]|=
-					hexVal(data->wbuffer[j+i*6*3]);
+					hex_to_bin(data->wbuffer[j+i*6*3]);
 				break;
 			}
 		}
@@ -5329,10 +5322,10 @@ static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
 	for( i = 0; i < 16*3 && data->wbuffer[i+j]; i++ ) {
 		switch(i%3) {
 		case 0:
-			key[i/3] = hexVal(data->wbuffer[i+j])<<4;
+			key[i/3] = hex_to_bin(data->wbuffer[i+j])<<4;
 			break;
 		case 1:
-			key[i/3] |= hexVal(data->wbuffer[i+j]);
+			key[i/3] |= hex_to_bin(data->wbuffer[i+j]);
 			break;
 		}
 	}
-- 
1.6.3.3

