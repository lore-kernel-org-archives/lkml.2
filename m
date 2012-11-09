Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2KIOHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:07:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab2KIOHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:07:33 -0500
From: Tomas Hozza <thozza@redhat.com>
To: olaf@aepfle.de, kys@microsoft.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        apw@canonical.com, jasowang@redhat.com, ben@decadent.org.uk
Cc: Tomas Hozza <thozza@redhat.com>
Subject: [PATCH 2/3] tools/hv: Fix string types
Date: Fri,  9 Nov 2012 15:01:20 +0100
Message-Id: <1352469681-4432-2-git-send-email-thozza@redhat.com>
In-Reply-To: <1352469681-4432-1-git-send-email-thozza@redhat.com>
References: <1352469681-4432-1-git-send-email-thozza@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial patch by Ben Hutchings <ben@decadent.org.uk>

Standard C strings are arrays of char, not __u8 (unsigned char).
Declare variables and parameters accordingly, and add the necessary
casts.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index d9b3a74..573b9aa 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -300,7 +300,7 @@ static int kvp_file_init(void)
 	return 0;
 }
 
-static int kvp_key_delete(int pool, __u8 *key, int key_size)
+static int kvp_key_delete(int pool, const char *key, int key_size)
 {
 	int i;
 	int j, k;
@@ -343,7 +343,7 @@ static int kvp_key_delete(int pool, __u8 *key, int key_size)
 	return 1;
 }
 
-static int kvp_key_add_or_modify(int pool, __u8 *key, int key_size, __u8 *value,
+static int kvp_key_add_or_modify(int pool, const char *key, int key_size, const char *value,
 			int value_size)
 {
 	int i;
@@ -397,7 +397,7 @@ static int kvp_key_add_or_modify(int pool, __u8 *key, int key_size, __u8 *value,
 	return 0;
 }
 
-static int kvp_get_value(int pool, __u8 *key, int key_size, __u8 *value,
+static int kvp_get_value(int pool, const char *key, int key_size, char *value,
 			int value_size)
 {
 	int i;
@@ -429,8 +429,8 @@ static int kvp_get_value(int pool, __u8 *key, int key_size, __u8 *value,
 	return 1;
 }
 
-static int kvp_pool_enumerate(int pool, int index, __u8 *key, int key_size,
-				__u8 *value, int value_size)
+static int kvp_pool_enumerate(int pool, int index, char *key, int key_size,
+				char *value, int value_size)
 {
 	struct kvp_record *record;
 
-- 
1.7.11.7

