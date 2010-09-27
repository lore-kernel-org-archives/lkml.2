Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0I0Fod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:33 -0400
Received: from crca.org.au ([74.207.252.120]:36071 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab0I0Fob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:31 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 16/23] Remove first_sector from swap_map_handle
Date: Mon, 27 Sep 2010 15:43:51 +1000
Message-Id: <1285566238-10966-17-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the 'first_sector' variable from the swap_map_handle
struct. It will continue to be used whereas the other members
of the struct will be deleted in a following patch.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index f2bc044..e6709db 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -140,10 +140,10 @@ struct swap_map_page {
 struct swap_map_handle {
 	struct swap_map_page *cur;
 	sector_t cur_swap;
-	sector_t first_sector;
 	unsigned int k;
 };
 
+static sector_t first_sector;
 static struct swap_map_handle handle;
 
 extern struct hib_extent_state sector_extents;
@@ -159,7 +159,7 @@ unsigned int hib_bio_overhead(unsigned int nr_pages)
 /* Get the first sector of the image proper, for storing in the signature */
 sector_t hib_get_first_sector(void)
 {
-	return handle.first_sector;
+	return first_sector;
 }
 
 /**
@@ -213,7 +213,7 @@ int hib_bio_prepare_write(void)
 		return result;
 	}
 
-	handle.first_sector = hib_extent_current(&sector_extents);
+	first_sector = hib_extent_current(&sector_extents);
 
 	result = hib_extents_store(&sector_extents);
 	result2 = hib_flush_write_buffer();
-- 
1.7.0.4

