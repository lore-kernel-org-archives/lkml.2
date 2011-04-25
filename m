Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab1DYUol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:44:41 -0400
Received: from 1wt.eu ([62.212.114.60]:34318 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab1DYUYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:48 -0400
Message-Id: <20110425200238.339271381@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 123/173] irda: validate peer name and attribute lengths
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit d370af0ef7951188daeb15bae75db7ba57c67846 upstream.

Length fields provided by a peer for names and attributes may be longer
than the destination array sizes.  Validate lengths to prevent stack
buffer overflows.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/irda/iriap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/irda/iriap.c
+++ b/net/irda/iriap.c
@@ -655,10 +655,16 @@ static void iriap_getvaluebyclass_indica
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
 


