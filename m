Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab2JONK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:10:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab2JONK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:10:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] UM: linux/coredump.h needs siginfo_t
To: jdike@addtoit.com, richard@nod.at
Cc: rdunlap@xenotime.net, dhowells@redhat.com,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Oct 2012 14:10:34 +0100
Message-ID: <20121015131034.8834.52811.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/coredump.h should #include asm/siginfo.h for the siginfo_t type.

Without this the following error occurs when compiling UM defconfig:

	include/linux/coredump.h:15:25: error: unknown type name 'siginfo_t'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/coredump.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 1775eb8..1d73993 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <asm/siginfo.h>
 
 /*
  * These are the only things you should do on a core-file: use only these

