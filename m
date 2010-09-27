Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab0I0FoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:17 -0400
Received: from crca.org.au ([74.207.252.120]:50165 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab0I0FoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:15 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 07/23] Hiberation: Fix speed display.
Date: Mon, 27 Sep 2010 15:43:42 +1000
Message-Id: <1285566238-10966-8-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the situation where, if an error occurs while writing an image,
the speed display still uses the number of pages that should have been
written, rather than the number of pages that were written.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/swap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 4c08329..fbda5cd 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -474,7 +474,7 @@ static int save_image(struct swap_map_handle *handle,
 		printk(KERN_CONT "\b\b\b\bdone\n");
 	else
 		printk(KERN_CONT "\n");
-	mps = swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
+	mps = swsusp_show_speed(&start, &stop, nr_pages, "Wrote");
 	write_speed = (mps < 256) ? (char) mps : 0;
 	return ret;
 }
-- 
1.7.0.4

