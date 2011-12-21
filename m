Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1LUBhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:37:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45581 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931Ab1LUBhD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:37:03 -0500
Message-ID: <1324431418.2844.154.camel@deadeye>
Subject: [PATCH 7/8] rds: Pass pointers to virt_to_page(), not integers
From: Ben Hutchings <ben@decadent.org.uk>
To: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        rds-devel@oss.oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 01:36:58 +0000
In-Reply-To: <1324430940.2844.144.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures define virt_to_page() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on MIPS.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/rds/message.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index f0a4658..ccd3de5 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -257,7 +257,7 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
 		sg_set_page(&rm->data.op_sg[i],
-				virt_to_page(page_addrs[i]),
+				virt_to_page((void *)page_addrs[i]),
 				PAGE_SIZE, 0);
 	}
 
-- 
1.7.7.3



