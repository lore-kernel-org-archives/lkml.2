Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab1HBEwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:52:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33003 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab1HBEwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:52:42 -0400
Date: Tue, 2 Aug 2011 14:52:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the moduleh tree with Linus' tree
Message-Id: <20110802145237.e8b90cff7f6954f6a12d8b3b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/video/omap2/dss/rfbi.c between commit 24e6289c029b ("OMAP: DSS2:
remove extra includes from include/video/omapdss.h") from Linus' tree and
commit 06e632e042aa ("video: Add export.h for THIS_MODULE/EXPORT_SYMBOL
to drivers/video") from the moduleh tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/omap2/dss/rfbi.c
index 39f4c59,5dbd229..0000000
--- a/drivers/video/omap2/dss/rfbi.c
+++ b/drivers/video/omap2/dss/rfbi.c
@@@ -33,8 -33,7 +33,9 @@@
  #include <linux/hrtimer.h>
  #include <linux/seq_file.h>
  #include <linux/semaphore.h>
 +#include <linux/platform_device.h>
 +#include <linux/pm_runtime.h>
+ #include <linux/export.h>
  
  #include <video/omapdss.h>
  #include "dss.h"
