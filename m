Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab0HQPYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0HQPYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:24:13 -0400
Message-ID: <4C6AA995.6040008@redhat.com>
Date: Tue, 17 Aug 2010 17:24:05 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>
CC: ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: [PATCH] ecryptfs: properly mark init functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some ecryptfs init functions are not prefixed by __init and thus not
freed after initialization. This patch saved about 1kB in ecryptfs
module.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 crypto.c    |    2 +-
 kthread.c   |    2 +-
 messaging.c |    2 +-
 miscdev.c   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index a2e3b56..13ff48b 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1793,7 +1793,7 @@ struct kmem_cache *ecryptfs_key_tfm_cache;
 static struct list_head key_tfm_list;
 struct mutex key_tfm_list_mutex;
 
-int ecryptfs_init_crypto(void)
+int __init ecryptfs_init_crypto(void)
 {
 	mutex_init(&key_tfm_list_mutex);
 	INIT_LIST_HEAD(&key_tfm_list);
diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index d8c3a37..0851ab6 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -86,7 +86,7 @@ out:
 	return 0;
 }
 
-int ecryptfs_init_kthread(void)
+int __init ecryptfs_init_kthread(void)
 {
 	int rc = 0;
 
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index bcb68c0..ab22480 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -473,7 +473,7 @@ sleep:
 	return rc;
 }
 
-int ecryptfs_init_messaging(void)
+int __init ecryptfs_init_messaging(void)
 {
 	int i;
 	int rc = 0;
diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 3745f61..00208c3 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -500,7 +500,7 @@ static struct miscdevice ecryptfs_miscdev = {
  *
  * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_init_ecryptfs_miscdev(void)
+int __init ecryptfs_init_ecryptfs_miscdev(void)
 {
 	int rc;
 
