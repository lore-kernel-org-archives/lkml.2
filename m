Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009Ab1C3VeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:34:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:26944 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964970Ab1C3VIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238003"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: error27@gmail.com, schwidefsky@de.ibm.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [174/275] keyboard: integer underflow bug
Message-Id: <20110330210656.E63043E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Carpenter <error27@gmail.com>

commit b652277b09d3d030cb074cc6a98ba80b34244c03 upstream.

The "ct" variable should be an unsigned int.  Both struct kbdiacrs
->kb_cnt and struct kbd_data ->accent_table_size are unsigned ints.

Making it signed causes a problem in KBDIACRUC because the user could
set the signed bit and cause a buffer overflow.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/s390/char/keyboard.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/s390/char/keyboard.c
===================================================================
--- linux-2.6.35.y.orig/drivers/s390/char/keyboard.c	2011-03-29 22:50:54.267869839 -0700
+++ linux-2.6.35.y/drivers/s390/char/keyboard.c	2011-03-29 23:03:01.863252494 -0700
@@ -460,7 +460,8 @@
 	  unsigned int cmd, unsigned long arg)
 {
 	void __user *argp;
-	int ct, perm;
+	unsigned int ct;
+	int perm;
 
 	argp = (void __user *)arg;
 
