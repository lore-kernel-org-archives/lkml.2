Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2KIOEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:04:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab2KIOEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:04:51 -0500
From: Tomas Hozza <thozza@redhat.com>
To: olaf@aepfle.de, kys@microsoft.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        apw@canonical.com, jasowang@redhat.com, ben@decadent.org.uk
Cc: Tomas Hozza <thozza@redhat.com>
Subject: [PATCH 1/3] tools/hv: Fix /var subdirectory
Date: Fri,  9 Nov 2012 15:01:19 +0100
Message-Id: <1352469681-4432-1-git-send-email-thozza@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial patch by Ben Hutchings <ben@decadent.org.uk>

We will install this in /usr, so it must use /var/lib for its state.
Only programs installed under /opt should use /var/opt.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 54ecb95..d9b3a74 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -98,7 +98,7 @@ static struct utsname uts_buf;
  * The location of the interface configuration file.
  */
 
-#define KVP_CONFIG_LOC	"/var/opt/"
+#define KVP_CONFIG_LOC	"/var/lib/"
 
 #define MAX_FILE_NAME 100
 #define ENTRIES_PER_BLOCK 50
@@ -235,9 +235,9 @@ static int kvp_file_init(void)
 	int i;
 	int alloc_unit = sizeof(struct kvp_record) * ENTRIES_PER_BLOCK;
 
-	if (access("/var/opt/hyperv", F_OK)) {
-		if (mkdir("/var/opt/hyperv", S_IRUSR | S_IWUSR | S_IROTH)) {
-			syslog(LOG_ERR, " Failed to create /var/opt/hyperv");
+	if (access("/var/lib/hyperv", F_OK)) {
+		if (mkdir("/var/lib/hyperv", S_IRUSR | S_IWUSR | S_IROTH)) {
+			syslog(LOG_ERR, " Failed to create /var/lib/hyperv");
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -246,7 +246,7 @@ static int kvp_file_init(void)
 		fname = kvp_file_info[i].fname;
 		records_read = 0;
 		num_blocks = 1;
-		sprintf(fname, "/var/opt/hyperv/.kvp_pool_%d", i);
+		sprintf(fname, "/var/lib/hyperv/.kvp_pool_%d", i);
 		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IROTH);
 
 		if (fd == -1)
-- 
1.7.11.7

