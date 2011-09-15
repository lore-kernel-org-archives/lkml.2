Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1IOHHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:07:24 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44816 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IOHHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:07:23 -0400
Date: Thu, 15 Sep 2011 17:07:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the final tree (security
 tree related)
Message-Id: <20110915170715.a380a5be954efc5891386ee3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

security/keys/encrypted-keys/masterkey_trusted.c: In function 'request_trusted_key':
security/keys/encrypted-keys/masterkey_trusted.c:35:2: error: implicit declaration of function 'IS_ERR'

Caused by commit 982e617a313b ("encrypted-keys: remove trusted-keys
dependency").  Forgot to include linux/err.h.  See Rule 1 in
Documentation/SubmitChecklist.

I have applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 15 Sep 2011 17:03:09 +1000
Subject: [PATCH] encrypted-keys: IS_ERR need include/err.h

Fixes this build error:

security/keys/encrypted-keys/masterkey_trusted.c: In function 'request_trusted_key':
security/keys/encrypted-keys/masterkey_trusted.c:35:2: error: implicit declaration of function 'IS_ERR'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 security/keys/encrypted-keys/masterkey_trusted.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/keys/encrypted-keys/masterkey_trusted.c b/security/keys/encrypted-keys/masterkey_trusted.c
index a5da512..df87272 100644
--- a/security/keys/encrypted-keys/masterkey_trusted.c
+++ b/security/keys/encrypted-keys/masterkey_trusted.c
@@ -16,6 +16,7 @@
 
 #include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/err.h>
 #include <keys/trusted-type.h>
 
 /*
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
