Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1GUXKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:10:51 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:53814 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752187Ab1GUXKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:10:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pVYP/ezikmNJHZ1q5lHtObg4CcfkGRVyanlP2crfkkFd+EwY7xmXD7EL6dbmIOiQX38urmJpK0W5utuDr1so+2NVcIIt0JqBy2Va3A9eHsJNmswNg+HUzVvVqO49GXYb;
Date: Thu, 21 Jul 2011 16:10:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH -next] dm: fix dm-flakey printk warning
Message-Id: <20110721161047.8a62d89a.rdunlap@xenotime.net>
In-Reply-To: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
References: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning for sector_t, which can be (unsigned)
long or long long.

drivers/md/dm-flakey.c:257: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'sector_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/md/dm-flakey.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20110721.orig/drivers/md/dm-flakey.c
+++ linux-next-20110721/drivers/md/dm-flakey.c
@@ -255,10 +255,11 @@ static void corrupt_bio_data(struct bio 
 		data[fc->corrupt_bio_byte - 1] = fc->corrupt_bio_value;
 
 		DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
-			"(rw=%c bi_rw=%lu bi_sector=%lu cur_bytes=%u)\n",
+			"(rw=%c bi_rw=%lu bi_sector=%llu cur_bytes=%u)\n",
 			bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
 			(bio_data_dir(bio) == WRITE) ? 'w' : 'r',
-			bio->bi_rw, bio->bi_sector, bio_bytes);
+			bio->bi_rw, (unsigned long long)bio->bi_sector,
+			bio_bytes);
 	}
 }
 
