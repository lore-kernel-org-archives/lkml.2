Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0LQQDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:03:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab0LQQDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:03:21 -0500
Message-ID: <4D0B89C3.8000802@redhat.com>
Date: Fri, 17 Dec 2010 17:03:15 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: [PATCH 3/4] Staging: zram: make zram_read return a bio error if the
 device is not initialized
References: <4D0B88E5.4040005@redhat.com>
In-Reply-To: <4D0B88E5.4040005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make zram_read() return a bio error if the device is not initialized
instead of pretending nothing happened.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d649b3e..4085958 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -208,8 +208,7 @@ static int zram_read(struct zram *zram, struct bio *bio)
 	struct bio_vec *bvec;
 
 	if (unlikely(!zram->init_done)) {
-		set_bit(BIO_UPTODATE, &bio->bi_flags);
-		bio_endio(bio, 0);
+		bio_endio(bio, -ENXIO);
 		return 0;
 	}
 

