Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478Ab0EZHKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:10:22 -0400
Received: from crca.org.au ([74.207.252.120]:40252 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934396Ab0EZHKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:10:19 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BFCC956.1070205@crca.org.au>
Date: Wed, 26 May 2010 17:10:14 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 5/5] Hiberation: Fix speed display
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
index ff2fc15..1e6e5b6 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -485,7 +485,7 @@ static int save_image(struct swap_map_handle *handle,
  		printk(KERN_CONT "\b\b\b\bdone\n");
  	else
  		printk(KERN_CONT "\n");
-	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
+	swsusp_show_speed(&start, &stop, nr_pages, "Wrote");
  	return ret;
  }

-- 
1.7.0.4

