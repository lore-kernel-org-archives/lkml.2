Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab2HPBhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:37:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab2HPBh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:37:28 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/25] MODSIGN: Provide gitignore and make clean rules for
 extra files
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 02:37:19 +0100
Message-ID: <20120816013719.872.46590.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
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
 2 files changed, 14 insertions(+)


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
index ddf5be9..70a6b5b 100644
--- a/Makefile
+++ b/Makefile
@@ -1239,6 +1239,7 @@ clean: $(clean-dirs)
 	$(call cmd,rmfiles)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
+		-o -name '*.ko.*' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
 		-o -name modules.builtin -o -name '.tmp_*.o.*' \

