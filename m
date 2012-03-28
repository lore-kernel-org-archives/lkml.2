Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab2C1Ksd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:48:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069Ab2C1Kq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:46:26 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/9] keys: update the description with info about "logon" keys
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Date: Wed, 28 Mar 2012 11:46:19 +0100
Message-ID: <20120328104619.10417.78851.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120328104607.10417.85745.stgit@warthog.procyon.org.uk>
References: <20120328104607.10417.85745.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys.txt |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 7877170..4c8cf36 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -123,7 +123,7 @@ KEY SERVICE OVERVIEW
 
 The key service provides a number of features besides keys:
 
- (*) The key service defines two special key types:
+ (*) The key service defines three special key types:
 
      (+) "keyring"
 
@@ -137,6 +137,19 @@ The key service provides a number of features besides keys:
 	 blobs of data. These can be created, updated and read by userspace,
 	 and aren't intended for use by kernel services.
 
+     (+) "logon"
+
+         Like a "user" key, a "logon" key has a payload that is an arbitrary
+         blob of data. It is intended as a place to store secrets that the
+         to which the kernel should have access but that should not be
+         accessable from userspace.
+
+         The description can be arbitrary, but must be prefixed with a non-zero
+         length string that describes the key "subclass". The subclass is
+         separated from the rest of the description by a ':'. "logon" keys can
+         be created and updated by userspace, but the payload is only readable
+         from kernel space.
+
  (*) Each process subscribes to three keyrings: a thread-specific keyring, a
      process-specific keyring, and a session-specific keyring.
 

