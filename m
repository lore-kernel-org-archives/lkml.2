Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab0I0Fsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:48:39 -0400
Received: from crca.org.au ([74.207.252.120]:60132 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657Ab0I0FoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:12 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 05/23] Hibernation: Add mass swap allocation routine
Date: Mon, 27 Sep 2010 15:43:40 +1000
Message-Id: <1285566238-10966-6-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a routine to allocate swap from a device en masse. This is only
for use by the in-kernel implementation, not uswsusp.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/swap.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 25090ed..e597756 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -169,6 +169,19 @@ sector_t alloc_swapdev_block(int swap)
 	return 0;
 }
 
+int alloc_swapdev_blocks(int needed)
+{
+	int i;
+
+	for (i = 0; i < needed; i++) {
+		sector_t res = alloc_swapdev_block(root_swap);
+		if (!res)
+			break;
+	}
+
+	return i;
+}
+
 /**
  *	free_all_swap_pages - free swap pages allocated for saving image data.
  *	It also frees the extents used to register which swap entries had been
-- 
1.7.0.4

