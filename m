Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323Ab1C3VKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:10:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:44838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965267Ab1C3VJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621239294"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: john@Calva.COM, James.Bottomley@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [250/275] ses: show devices for enclosures with no page 7
Message-Id: <20110330210816.E33E33E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: John Hughes <john@Calva.COM>

commit 877a55979c189c590e819a61cbbe2b7947875f17 upstream.

enclosure page 7 gives us the "pretty" names of the enclosure slots.
Without a page 7, we can still use the enclosure code as long as we
make up numeric names for the slots. Unfortunately, the current code
fails to add any devices because the check for page 10 is in the wrong
place if we have no page 7.  Fix it so that devices show up even if
the enclosure has no page 7.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/ses.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/scsi/ses.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/ses.c	2011-03-29 22:50:11.521963601 -0700
+++ linux-2.6.35.y/drivers/scsi/ses.c	2011-03-29 23:03:03.484211019 -0700
@@ -390,9 +390,9 @@
 		len = (desc_ptr[2] << 8) + desc_ptr[3];
 		/* skip past overall descriptor */
 		desc_ptr += len + 4;
-		if (ses_dev->page10)
-			addl_desc_ptr = ses_dev->page10 + 8;
 	}
+	if (ses_dev->page10)
+		addl_desc_ptr = ses_dev->page10 + 8;
 	type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
 	components = 0;
 	for (i = 0; i < types; i++, type_ptr += 4) {
