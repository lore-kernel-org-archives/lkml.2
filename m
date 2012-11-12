Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2KLI4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 03:56:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab2KLI4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 03:56:17 -0500
From: Tomas Hozza <thozza@redhat.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com, ben@decadent.org.uk
Cc: Tomas Hozza <thozza@redhat.com>
Subject: [PATCH 3/3] tools/hv: Fix permissions of created directory and files
Date: Mon, 12 Nov 2012 09:55:06 +0100
Message-Id: <1352710506-12590-3-git-send-email-thozza@redhat.com>
In-Reply-To: <1352710506-12590-1-git-send-email-thozza@redhat.com>
References: <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
 <1352710506-12590-1-git-send-email-thozza@redhat.com>
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
index a581b3f..17703c7 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -236,7 +236,7 @@ static int kvp_file_init(void)
 	int alloc_unit = sizeof(struct kvp_record) * ENTRIES_PER_BLOCK;
 
 	if (access(KVP_CONFIG_LOC, F_OK)) {
-		if (mkdir(KVP_CONFIG_LOC, S_IRUSR | S_IWUSR | S_IROTH)) {
+		if (mkdir(KVP_CONFIG_LOC, 0755 /* rwxr-xr-x */)) {
 			syslog(LOG_ERR, " Failed to create %s", KVP_CONFIG_LOC);
 			exit(EXIT_FAILURE);
 		}
@@ -247,7 +247,7 @@ static int kvp_file_init(void)
 		records_read = 0;
 		num_blocks = 1;
 		sprintf(fname, "%s/.kvp_pool_%d", KVP_CONFIG_LOC, i);
-		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IROTH);
+		fd = open(fname, O_RDWR | O_CREAT, 0644 /* rw-r--r-- */);
 
 		if (fd == -1)
 			return 1;
-- 
1.7.11.7

