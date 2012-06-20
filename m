Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2FTS2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:28:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2FTSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:31 -0400
Message-Id: <20120620173040.368325432@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Janne=20Kalliom=C3=A4ki?= <janne@tuxera.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [ 09/20] hfsplus: fix overflow in sector calculations in hfsplus_submit_bio
In-Reply-To: <20120620173044.GA6910@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hfsplus/wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -56,7 +56,7 @@ int hfsplus_submit_bio(struct super_bloc
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct bio *bio;
 	int ret = 0;
-	unsigned int io_size;
+	u64 io_size;
 	loff_t start;
 	int offset;
 


