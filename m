Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394Ab0EZHKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:10:12 -0400
Received: from crca.org.au ([74.207.252.120]:57629 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934362Ab0EZHKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:10:08 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BFCC94C.2050706@crca.org.au>
Date: Wed, 26 May 2010 17:10:04 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 3/5] Hibernation: Add mass swap allocation routine.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
index e555b6c..550c1ed 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -187,6 +187,19 @@ sector_t alloc_swapdev_block(int swap)
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
   *	It also frees the extents used to register which swap entres had been
-- 
1.7.0.4

