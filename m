Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1I1ISZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:18:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44371 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1I1ISV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:18:21 -0400
Date: Wed, 28 Sep 2011 18:18:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>, Chris Ball <cjb@laptop.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110928181815.45f540034ddde2b206fc4e57@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/mmc/core/debugfs.c:28:35: error: expected ')' before numeric constant

Caused by commit b5a62f8be3af ("mmc: add module param to set fault
injection attributes") from the mmc tree interacting with the module.h
split up.

I have applied the patch below for today (something similar could be
applied to the mmc tree).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 18:09:12 +1000
Subject: [PATCH] mmc: using mopdule_param requires the inclusion of
 moduleparam.h

Otherwise the module.h split up produces this error:

drivers/mmc/core/debugfs.c:28:35: error: expected ')' before numeric constant

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mmc/core/debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 0a1e7cf..f9e9ff0 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -9,6 +9,7 @@
  */
 #include <linux/debugfs.h>
 #include <linux/fs.h>
+#include <linux/moduleparam.h>
 #include <linux/export.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-- 
1.7.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
