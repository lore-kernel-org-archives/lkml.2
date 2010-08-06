Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935221Ab0HFCOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:14:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380Ab0HFCN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:13:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] cifs: Include linux/err.h for IS_ERR and PTR_ERR
To: smfrench@gmail.com
Cc: jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>
Date: Fri, 06 Aug 2010 03:13:47 +0100
Message-ID: <20100806021347.29873.87087.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Fixes build errors:

net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
net/dns_resolver/dns_key.c:170: error: implicit declaration of function 'IS_ERR'
net/dns_resolver/dns_key.c:171: error: implicit declaration of function 'PTR_ERR'
net/dns_resolver/dns_query.c: In function 'dns_query':
net/dns_resolver/dns_query.c:126: error: implicit declaration of function 'IS_ERR'
net/dns_resolver/dns_query.c:127: error: implicit declaration of function 'PTR_ERR'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David Howells <dhowells@redhat.com>
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
 

