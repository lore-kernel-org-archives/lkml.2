Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030840Ab2HQDfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:35:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46747 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030632Ab2HQD04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:56 -0400
Message-Id: <20120817030246.109298286@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Janne=20Kalliom=C3=A4ki?= <janne@tuxera.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [ 15/37] hfsplus: fix overflow in sector calculations in hfsplus_submit_bio
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Kalliomäki <janne@tuxera.com>

commit a6dc8c04218eb752ff79cdc24a995cf51866caed upstream.

The variable io_size was unsigned int, which caused the wrong sector number
to be calculated after aligning it. This then caused mount to fail with big
volumes, as backup volume header information was searched from a
wrong sector.

Signed-off-by: Janne Kalliomäki <janne@tuxera.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/hfsplus/wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 7daf4b8..90effcc 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -56,7 +56,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct bio *bio;
 	int ret = 0;
-	unsigned int io_size;
+	u64 io_size;
 	loff_t start;
 	int offset;
 


