Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab1IIRoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:44:14 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52017 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab1IIRoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:44:12 -0400
Message-ID: <4E6A4AA7.5050004@vflare.org>
Date: Fri, 09 Sep 2011 13:19:35 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5 resend] Fix sparse warnings
References: <1315445357-14338-1-git-send-email-ngupta@vflare.org> <1315445357-14338-2-git-send-email-ngupta@vflare.org>
In-Reply-To: <1315445357-14338-2-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warning:
zram_drv.c:666:6: warning: symbol 'zram_slot_free_notify' was not
declared. Should it be static?

Also, max_zpage_size is now size_t just to be consistent with data-type
of other variables maintaining sizes of various kinds.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/zram_drv.c |    3 ++-
 drivers/staging/zram/zram_drv.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d70ec1a..03ec5a2 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -684,7 +684,8 @@ fail:
 	return ret;
 }
 
-void zram_slot_free_notify(struct block_device *bdev, unsigned long index)
+static void zram_slot_free_notify(struct block_device *bdev,
+				unsigned long index)
 {
 	struct zram *zram;
 
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index abe5221..70ce886 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -47,7 +47,7 @@ static const unsigned default_disksize_perc_ram = 25;
  * Pages that compress to size greater than this are stored
  * uncompressed in memory.
  */
-static const unsigned max_zpage_size = PAGE_SIZE / 4 * 3;
+static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
 
 /*
  * NOTE: max_zpage_size must be less than or equal to:
-- 
1.7.6

