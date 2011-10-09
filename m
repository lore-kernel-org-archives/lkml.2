Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab1JIFId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 01:08:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:45166 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1JIFIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 01:08:32 -0400
Date: Sun, 9 Oct 2011 01:08:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Chris Ball <cjb@laptop.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Per Forlin <per.forlin@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20111009050809.GS19986@windriver.com>
References: <20110928181815.45f540034ddde2b206fc4e57@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110928181815.45f540034ddde2b206fc4e57@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build failure after merge of the moduleh tree] On 28/09/2011 (Wed 18:18) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/mmc/core/debugfs.c:28:35: error: expected ')' before numeric constant
> 
> Caused by commit b5a62f8be3af ("mmc: add module param to set fault
> injection attributes") from the mmc tree interacting with the module.h
> split up.
> 
> I have applied the patch below for today (something similar could be
> applied to the mmc tree).

Hi Chris,

I was wondering if you were going to apply this to the mmc tree.  Since
the module_param addition isn't in the module.h baseline, I'd be
speculatively fixing an issue that hasn't been created yet, which isn't
the end of the world, but it doesn't feel quite right to do that either.

If it is in the mmc tree, then the include fix will be guaranteed to be
present wherever the module_param usage is present.

Thanks,
Paul.


>From 00812c67db3d0ade3571684191781d866293f1ba Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 18:09:12 +1000
Subject: [PATCH] mmc: using module_param requires the inclusion of
 moduleparam.h

Commit "mmc: add module param to set fault injection attributes" adds
a module_param to this file.  But it is relying on the old implicit
"module.h is everywhere" behaviour, and without the explicit include
of moduleparam.h, the pending module.h split up produces this error:

drivers/mmc/core/debugfs.c:28:35: error: expected ')' before numeric constant

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 0a1e7cf..65138e0 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -7,6 +7,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/moduleparam.h>
 #include <linux/debugfs.h>
 #include <linux/fs.h>
 #include <linux/export.h>
-- 
1.7.6



