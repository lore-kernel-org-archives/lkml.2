Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1BRD5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:57:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49594 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab1BRD5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:57:49 -0500
Date: Fri, 18 Feb 2011 14:57:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: build failure after merge of the workqueues tree
Message-Id: <20110218145747.f4b26b91.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

After merging the workqueues tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/input/input-polldev.c: In function 'input_polldev_init':
drivers/input/input-polldev.c:259: error: 'WQ_FREEZEABLE' undeclared (first use in this function)

Caused by commit 58a69cb47ec6991bf006a3e5d202e8571b0327a4 ("workqueue,
freezer: unify spelling of 'freeze' + 'able' to 'freezable'") interacting
with commit 8fb3f6f6bf6e17e97712d216f230ba05f2e88ed8 ("Input:
input-polldev - create workqueue upfront") from the input tree.

I applied the following fix up patch (and can carry it as necessary):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 18 Feb 2011 14:50:46 +1100
Subject: [PATCH] input: update for FREEZEABLE -> FREEZABLE change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/input/input-polldev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index 0a5304c..d89e9a9 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -257,7 +257,7 @@ static int __init input_polldev_init(void)
 	 * system goes into sleep mode.
 	 */
 	polldev_wq = alloc_workqueue("ipolldev_wq",
-				     WQ_FREEZEABLE | WQ_UNBOUND, 0);
+				     WQ_FREEZABLE | WQ_UNBOUND, 0);
 	if (!polldev_wq) {
 		pr_err("failed to create ipolldev_wq workqueue\n");
 		return -ENOMEM;
-- 
1.7.2.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
