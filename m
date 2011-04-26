Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab1DZVjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:39:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:60166 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569Ab1DZVNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684326757"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: drosenberg@vsecurity.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [9/106] irda: validate peer name and attribute lengths
Message-Id: <20110426211247.3CC9A3E1887@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

commit d370af0ef7951188daeb15bae75db7ba57c67846 upstream.

Length fields provided by a peer for names and attributes may be longer
than the destination array sizes.  Validate lengths to prevent stack
buffer overflows.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/irda/iriap.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.35.y/net/irda/iriap.c
===================================================================
--- linux-2.6.35.y.orig/net/irda/iriap.c
+++ linux-2.6.35.y/net/irda/iriap.c
@@ -656,10 +656,16 @@ static void iriap_getvaluebyclass_indica
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
 
