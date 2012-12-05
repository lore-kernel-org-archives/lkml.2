Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2LEUvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:51:31 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37428 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754015Ab2LEUv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:51:29 -0500
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2012 15:51:29 EST
From: Sebastian Hahn <snsehahn@cip.cs.fau.de>
To: gregkh@linuxfoundation.org
Cc: Jennifer.Naumann@informatik.stud.uni-erlangen.de, dan.carpenter@oracle.com,
        standby24x7@gmail.com, Julia.Lawall@lip6.fr, jkosina@suse.cz,
        joe@perches.com, yongjun_wei@trendmicro.com.cn,
        adam.buchbinder@gmail.com, amwang@redhat.com, justinmattock@gmail.com,
        wfp5p@virginia.edu, jim.cromie@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Sebastian Hahn <snsehahn@cip.cs.fau.de>
Subject: [PATCH 4/6] staging/rtl8192u: don't init globals to 0 or NULL
Date: Wed,  5 Dec 2012 21:40:21 +0100
Message-Id: <1354740023-30849-5-git-send-email-snsehahn@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
References: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a couple of instances where checkpatch complained about
initializing globals with 0.

Signed-off-by: Sebastian Hahn <snsehahn@cip.cs.fau.de>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_module.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
index c673adc..76c56e5 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -220,7 +220,7 @@ void free_ieee80211(struct net_device *dev)
 
 #ifdef CONFIG_IEEE80211_DEBUG
 
-u32 ieee80211_debug_level = 0;
+u32 ieee80211_debug_level;
 static int debug = \
 	//		    IEEE80211_DL_INFO	|
 	//		    IEEE80211_DL_WX	|
@@ -241,7 +241,7 @@ static int debug = \
 			    //IEEE80211_DL_DATA	|
 			    IEEE80211_DL_ERR	  //awayls open this flags to show error out
 			    ;
-struct proc_dir_entry *ieee80211_proc = NULL;
+struct proc_dir_entry *ieee80211_proc;
 
 static int show_debug_level(char *page, char **start, off_t offset,
 			    int count, int *eof, void *data)
-- 
1.7.10.4

