Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab2EVXEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab2EVXEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:04:40 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/23] MODSIGN: Provide gitignore and make clean rules for
 extra files
To: rusty@rustcorp.com.au, kyle@mcmartin.ca
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, David Howells <dhowells@redhat.com>
Date: Wed, 23 May 2012 00:04:31 +0100
Message-ID: <20120522230431.24007.18277.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide gitignore and make clean rules for extra files to hide and clean up the
extra files produced by module signing stuff once it is added.  Also add a
clean up rule for the module content extractor program used to extract the data
to be signed.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 .gitignore |   13 +++++++++++++
 Makefile   |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)


diff --git a/.gitignore b/.gitignore
index 57af07c..4d63081 100644
--- a/.gitignore
+++ b/.gitignore
@@ -14,6 +14,10 @@
 *.o.*
 *.a
 *.s
+*.ko.unsigned
+*.ko.stripped
+*.ko.stripped.sig
+*.ko.trailer
 *.ko
 *.so
 *.so.dbg
@@ -84,3 +88,12 @@ GTAGS
 *.orig
 *~
 \#*#
+
+#
+# GPG leavings from module signing
+#
+genkey
+modsign.pub
+modsign.sec
+random_seed
+trustdb.gpg
diff --git a/Makefile b/Makefile
index a06ee9f..1df8b14 100644
--- a/Makefile
+++ b/Makefile
@@ -1407,6 +1407,7 @@ clean: $(clean-dirs)
 	$(call cmd,rmfiles)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
+		-o -name '*.ko.*' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
 		-o -name modules.builtin -o -name '.tmp_*.o.*' \

