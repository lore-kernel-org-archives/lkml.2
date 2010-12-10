Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0LJD32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:29:28 -0500
Received: from mail.perches.com ([173.55.12.10]:2473 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab0LJD3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:29:24 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] hid: simplify an index check in hid_lookup_collection
Date: Thu,  9 Dec 2010 19:29:08 -0800
Message-Id: <e7178835751a133007146aef5674edea96206ed2.1291951482.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
References: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
In-Reply-To: <cover.1291951482.git.joe@perches.com>
References: <cover.1291951482.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the struct hid_collection * in a temporary to shorten
the generated code a bit and perhaps improve readability.

$ size drivers/hid/hid-core.o*
   text	   data	    bss	    dec	    hex	filename
  16460	     78	      8	  16546	   40a2	drivers/hid/hid-core.o.new
  16469	     78	      8	  16555	   40ab	drivers/hid/hid-core.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/hid-core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 796012e..ee05170 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -178,10 +178,14 @@ static int close_collection(struct hid_parser *parser)
 
 static unsigned hid_lookup_collection(struct hid_parser *parser, unsigned type)
 {
+	struct hid_collection *collection = parser->device->collection;
 	int n;
-	for (n = parser->collection_stack_ptr - 1; n >= 0; n--)
-		if (parser->device->collection[parser->collection_stack[n]].type == type)
-			return parser->device->collection[parser->collection_stack[n]].usage;
+
+	for (n = parser->collection_stack_ptr - 1; n >= 0; n--) {
+		unsigned index = parser->collection_stack[n];
+		if (collection[index].type == type)
+			return collection[index].usage;
+	}
 	return 0; /* we know nothing about this usage type */
 }
 
-- 
1.7.3.3.464.gf80b6

