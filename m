Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab0CaATp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:19:45 -0400
Received: from kroah.org ([198.145.64.141]:51696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab0C3XRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:22 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:55:58 2010
Message-Id: <20100330225557.413764435@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Alain Knaff <alain@knaff.lu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [003/116] decompress: fix new decompressor for PIC
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Russell King <rmk@arm.linux.org.uk>

commit 5ceaa2f39bfa73c4398cd01e78f1c3ebde3d3383 upstream.

The ARM kernel decompressor wants to be able to relocate r/w data
independently from the rest of the image, and we do this by ensuring that
r/w data has global visibility.  Define STATIC_RW_DATA to be empty to
achieve this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Alain Knaff <alain@knaff.lu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/decompress/mm.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/decompress/mm.h
+++ b/include/linux/decompress/mm.h
@@ -14,11 +14,21 @@
 
 /* Code active when included from pre-boot environment: */
 
+/*
+ * Some architectures want to ensure there is no local data in their
+ * pre-boot environment, so that data can arbitarily relocated (via
+ * GOT references).  This is achieved by defining STATIC_RW_DATA to
+ * be null.
+ */
+#ifndef STATIC_RW_DATA
+#define STATIC_RW_DATA static
+#endif
+
 /* A trivial malloc implementation, adapted from
  *  malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
  */
-static unsigned long malloc_ptr;
-static int malloc_count;
+STATIC_RW_DATA unsigned long malloc_ptr;
+STATIC_RW_DATA int malloc_count;
 
 static void *malloc(int size)
 {


