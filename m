Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1CCC5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:57:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44000 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab1CCC5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:57:19 -0500
Date: Wed, 2 Mar 2011 20:57:13 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>, Nathan Lynch <ntl@pobox.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH mmotm 2/3] userns: don't define init_user_ns in
 ipc_namespace.h
Message-ID: <20110303025713.GA10138@peq.hallyn.com>
References: <20110303025603.GA10071@peq.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303025603.GA10071@peq.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It shouldn't be needed since ipc/msgutil.c includes security.h
which includes fs.h, which forward declares it.

---
 include/linux/ipc_namespace.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/include/linux/ipc_namespace.h
===================================================================
--- linux-2.6.orig/include/linux/ipc_namespace.h	2011-03-03 01:55:46.191177396 +0000
+++ linux-2.6/include/linux/ipc_namespace.h	2011-03-03 01:58:51.964414007 +0000
@@ -17,7 +17,6 @@
 #define IPCNS_CALLBACK_PRI 0
 
 struct user_namespace;
-extern struct user_namespace init_user_ns;
 
 struct ipc_ids {
 	int in_use;
