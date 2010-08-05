Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab0HEDvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:51:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47446 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758766Ab0HEDvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:51:50 -0400
Date: Thu, 5 Aug 2010 13:51:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wang Lei <wang840925@gmail.com>, David Howells <dhowells@redhat.com>
Subject: linux-next: build failure after merge of the final tree (cifs tree
 related)
Message-Id: <20100805135149.98b2001b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
net/dns_resolver/dns_key.c:170: error: implicit declaration of function 'IS_ERR'
net/dns_resolver/dns_key.c:171: error: implicit declaration of function 'PTR_ERR'
net/dns_resolver/dns_query.c: In function 'dns_query':
net/dns_resolver/dns_query.c:126: error: implicit declaration of function 'IS_ERR'
net/dns_resolver/dns_query.c:127: error: implicit declaration of function 'PTR_ERR'

Caused by commit bae8da144bd6254d1e9cec2a7d6da7cade84e00e ("DNS: Separate
out CIFS DNS Resolver code").

See Rule 1 in Documentation/SubmitChecklist.

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 5 Aug 2010 13:49:29 +1000
Subject: [PATCH] cifs: include linux/err.h for IS_ERR and PTR_ERR

Fixes build errors:

net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
net/dns_resolver/dns_key.c:170: error: implicit declaration of function 'IS_ERR'
net/dns_resolver/dns_key.c:171: error: implicit declaration of function 'PTR_ERR'
net/dns_resolver/dns_query.c: In function 'dns_query':
net/dns_resolver/dns_query.c:126: error: implicit declaration of function 'IS_ERR'
net/dns_resolver/dns_query.c:127: error: implicit declaration of function 'PTR_ERR'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/dns_resolver/dns_key.c   |    1 +
 net/dns_resolver/dns_query.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 1b1b411..400a04d 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -28,6 +28,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/keyctl.h>
+#include <linux/err.h>
 #include <keys/dns_resolver-type.h>
 #include <keys/user-type.h>
 #include "internal.h"
diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index 6c0cf31..b33e1f7 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -39,6 +39,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dns_resolver.h>
+#include <linux/err.h>
 #include <keys/dns_resolver-type.h>
 #include <keys/user-type.h>
 
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
