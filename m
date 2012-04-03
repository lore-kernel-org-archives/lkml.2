Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2DCSeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:34:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48473 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2DCSeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:34:21 -0400
From: Jeff Layton <jlayton@redhat.com>
To: dhowells@redhat.com
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] keys: update the documentation with info about "logon" keys
Date: Tue,  3 Apr 2012 14:34:15 -0400
Message-Id: <1333478055-17968-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 Documentation/security/keys.txt |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 7877170..1f5517a 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -123,7 +123,7 @@ KEY SERVICE OVERVIEW
 
 The key service provides a number of features besides keys:
 
- (*) The key service defines two special key types:
+ (*) The key service defines three special key types:
 
      (+) "keyring"
 
@@ -137,6 +137,18 @@ The key service provides a number of features besides keys:
 	 blobs of data. These can be created, updated and read by userspace,
 	 and aren't intended for use by kernel services.
 
+     (+) "logon"
+
+         Like a "user" key, a "logon" key has a payload that is an arbitrary
+         blob of data. It is intended as a place to store secrets which are
+	 accessible to the kernel but not to userspace programs.
+
+         The description can be arbitrary, but must be prefixed with a non-zero
+         length string that describes the key "subclass". The subclass is
+         separated from the rest of the description by a ':'. "logon" keys can
+         be created and updated from userspace, but the payload is only
+         readable from kernel space.
+
  (*) Each process subscribes to three keyrings: a thread-specific keyring, a
      process-specific keyring, and a session-specific keyring.
 
-- 
1.7.7.6

