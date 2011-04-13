Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab1DMQ1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:27:07 -0400
Received: from kroah.org ([198.145.64.141]:52787 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801Ab1DMQMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:44 2011
Message-Id: <20110413161044.476572408@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [19/71] irda: validate peer name and attribute lengths
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
 


