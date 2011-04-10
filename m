Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab1DJVcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:32:10 -0400
Received: from mail.perches.com ([173.55.12.10]:4626 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026Ab1DJVbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:31:36 -0400
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: Remove unnecessary semicolons when while (foo) {...};
Date: Sun, 10 Apr 2011 14:31:33 -0700
Message-Id: <31190234af48597c8f4ef543a9c6c1c7223dbbc8.1302470807.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302470807.git.joe@perches.com>
References: <cover.1302470807.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done via perl script:

$ cat remove_semi_while.pl
my $match_balanced_parentheses = qr/(\((?:[^\(\)]++|(?-1))*\))/;
my $match_balanced_braces      = qr/(\{(?:[^\{\}]++|(?-1))*\})/;

foreach my $file (@ARGV) {
    my $f;
    my $text;
    my $oldtext;

    next if ((-d $file));

    open($f, '<', $file)
	or die "$P: Can't open $file for read\n";
    $oldtext = do { local($/) ; <$f> };
    close($f);

    next if ($oldtext eq "");

    $text = $oldtext;

    my $count = 0;
    do {
	$count = 0;
	$count += $text =~ s@\b(while\s*${match_balanced_parentheses}\s*)${match_balanced_braces}\s*;@"$1$3"@egx;
    } while ($count > 0);

    if ($text ne $oldtext) {
	my $newfile = $file;

	open($f, '>', $newfile)
	    or die "$P: Can't open $newfile for write\n";
	print $f $text;
	close($f);
    }
}

$

One false positive removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rtl8712/rtl8712_recv.c             |    2 +-
 .../westbridge/astoria/block/cyasblkdev_block.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 569e14b..625a8a0 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -251,7 +251,7 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 		recvframe_put(prframe, pnfhdr->len);
 		pfhdr->attrib.icv_len = pnfhdr->attrib.icv_len;
 		plist = get_next(plist);
-	};
+	}
 exit:
 	/* free the defrag_q queue and return the prframe */
 	r8712_free_recvframe_queue(defrag_q, pfree_recv_queue);
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
index 289729d..87452bd 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
@@ -515,7 +515,7 @@ static void cyasblkdev_issuecallback(
 	while (blk_end_request(gl_bd->queue.req,
 	status, blk_rq_sectors(gl_bd->queue.req)*512)) {
 		retry_cnt++;
-	};
+	}
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message(
-- 
1.7.4.2.g597a6.dirty

