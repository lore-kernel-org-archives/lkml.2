Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab2CMARw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:17:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:46695 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025Ab2CMARr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 021/196] irda: validate peer name and attribute lengths
Date: Mon, 12 Mar 2012 20:12:29 -0400
Message-Id: <1331597724-31358-22-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d370af0ef7951188daeb15bae75db7ba57c67846 upstream.

Length fields provided by a peer for names and attributes may be longer
than the destination array sizes.  Validate lengths to prevent stack
buffer overflows.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/irda/iriap.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/irda/iriap.c b/net/irda/iriap.c
index b6fd6d1..26272fe 100644
--- a/net/irda/iriap.c
+++ b/net/irda/iriap.c
@@ -656,10 +656,16 @@ static void iriap_getvaluebyclass_indication(struct iriap_cb *self,
 	n = 1;
 
 	name_len = fp[n++];
+
+	IRDA_ASSERT(name_len < IAS_MAX_CLASSNAME + 1, return;);
+
 	memcpy(name, fp+n, name_len); n+=name_len;
 	name[name_len] = '\0';
 
 	attr_len = fp[n++];
+
+	IRDA_ASSERT(attr_len < IAS_MAX_ATTRIBNAME + 1, return;);
+
 	memcpy(attr, fp+n, attr_len); n+=attr_len;
 	attr[attr_len] = '\0';
 
-- 
1.7.9.3

