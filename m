Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1G1PuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:50:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab1G1PuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:50:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/40] UAPI: Add include/uapi/ directories to build [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:50:10 +0100
Message-ID: <20110728155010.16618.39768.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add include/uapi/ directories to build after the ordinary include directories
so that #include will pick up the UAPI header directly if the kernel header
has been moved there.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Makefile |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index d018956..68834a5 100644
--- a/Makefile
+++ b/Makefile
@@ -357,8 +357,12 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
-LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
-                   -Iarch/$(hdr-arch)/include/generated -Iinclude \
+LINUXINCLUDE    := \
+		-I$(srctree)/arch/$(hdr-arch)/include \
+		-Iarch/$(hdr-arch)/include/generated \
+		-I$(srctree)/arch/$(hdr-arch)/include/uapi \
+		-Iinclude \
+		-Iinclude/uapi \
                    $(if $(KBUILD_SRC), -I$(srctree)/include) \
                    -include include/generated/autoconf.h
 

