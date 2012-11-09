Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2KIODh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:03:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab2KIODe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:03:34 -0500
From: Tomas Hozza <thozza@redhat.com>
To: olaf@aepfle.de, kys@microsoft.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        apw@canonical.com, jasowang@redhat.com, ben@decadent.org.uk
Cc: Tomas Hozza <thozza@redhat.com>
Subject: [PATCH 3/3] tools/hv: Fix permissions of created directory and files
Date: Fri,  9 Nov 2012 15:01:21 +0100
Message-Id: <1352469681-4432-3-git-send-email-thozza@redhat.com>
In-Reply-To: <1352469681-4432-1-git-send-email-thozza@redhat.com>
References: <1352469681-4432-1-git-send-email-thozza@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

It's silly to create directories without execute permission, or to
give permissions to 'other' but not the group-owner.

Write the permissions in octal and 'ls -l' format since these are much
easier to read than the named macros.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Tomas Hozza <thozza@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 573b9aa..9609858 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -236,7 +236,7 @@ static int kvp_file_init(void)
 	int alloc_unit = sizeof(struct kvp_record) * ENTRIES_PER_BLOCK;
 
 	if (access("/var/lib/hyperv", F_OK)) {
-		if (mkdir("/var/lib/hyperv", S_IRUSR | S_IWUSR | S_IROTH)) {
+		if (mkdir("/var/lib/hyperv", 0755 /* rwxr-xr-x */)) {
 			syslog(LOG_ERR, " Failed to create /var/lib/hyperv");
 			exit(EXIT_FAILURE);
 		}
@@ -247,7 +247,7 @@ static int kvp_file_init(void)
 		records_read = 0;
 		num_blocks = 1;
 		sprintf(fname, "/var/lib/hyperv/.kvp_pool_%d", i);
-		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IROTH);
+		fd = open(fname, O_RDWR | O_CREAT, 0644 /* rw-r--r-- */);
 
 		if (fd == -1)
 			return 1;
-- 
1.7.11.7

