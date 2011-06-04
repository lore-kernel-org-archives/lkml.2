Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1FDPpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:45:49 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:48478 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab1FDPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:45:47 -0400
Date: Sat, 4 Jun 2011 17:36:43 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 6/8] drivers/gpu/drm: use printk_ratelimited instead of
 printk_ratelimit
Message-ID: <1a0239725c12da764545a3bd1118a386a0216645.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/gpu/drm/drm_ioc32.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index d61d185..4a058c7 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -28,6 +28,7 @@
  * IN THE SOFTWARE.
  */
 #include <linux/compat.h>
+#include <linux/ratelimit.h>
 
 #include "drmP.h"
 #include "drm_core.h"
@@ -253,10 +254,10 @@ static int compat_drm_addmap(struct file *file, unsigned int cmd,
 		return -EFAULT;
 
 	m32.handle = (unsigned long)handle;
-	if (m32.handle != (unsigned long)handle && printk_ratelimit())
-		printk(KERN_ERR "compat_drm_addmap truncated handle"
-		       " %p for type %d offset %x\n",
-		       handle, m32.type, m32.offset);
+	if (m32.handle != (unsigned long)handle)
+		printk_ratelimited(KERN_ERR "compat_drm_addmap truncated handle"
+				   " %p for type %d offset %x\n",
+				   handle, m32.type, m32.offset);
 
 	if (copy_to_user(argp, &m32, sizeof(m32)))
 		return -EFAULT;
-- 
1.7.1

