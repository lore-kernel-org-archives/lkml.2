Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1I1IZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:25:56 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49820 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1I1IZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:25:54 -0400
Date: Wed, 28 Sep 2011 18:25:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Assmann <sassmann@kpanic.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110928182549.2574857be45b6850c832c419@canb.auug.org.au>
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

drivers/net/wireless/rtlwifi/debug.c:32:21: error: expected ')' before 'uint'
drivers/net/wireless/rtlwifi/debug.c:33:25: error: expected ')' before string constant

Caused by commit b5be7e4c8f7b ("rtlwifi: add module parameter to set
global debug level") from the net tree interacting with the module.h
split up.

I have applied the following patch for today (and it could be applied to
the net or wireless trees).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 18:21:47 +1000
Subject: [PATCH] rtlwifi: use of module_param requires the inclusion of
 moduleparam.h

Otherwise the module.h split up will fail like this:

drivers/net/wireless/rtlwifi/debug.c:32:21: error: expected ')' before 'uint'
drivers/net/wireless/rtlwifi/debug.c:33:25: error: expected ')' before string constant

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/rtlwifi/debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/debug.c b/drivers/net/wireless/rtlwifi/debug.c
index b2f897a..e69aba9 100644
--- a/drivers/net/wireless/rtlwifi/debug.c
+++ b/drivers/net/wireless/rtlwifi/debug.c
@@ -26,6 +26,8 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *****************************************************************************/
 
+#include <linux/moduleparam.h>
+
 #include "wifi.h"
 
 static unsigned int debug = DBG_EMERG;
-- 
1.7.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
