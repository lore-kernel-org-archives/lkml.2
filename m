Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1G2Flt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 01:41:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38480 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab1G2Fls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 01:41:48 -0400
Date: Fri, 29 Jul 2011 15:41:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729154145.ee2a37c0e038088922202288@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/rc/ir-mce_kbd-decoder.c:446:16: error: expected declaration specifiers or '...' before string constant
drivers/media/rc/ir-mce_kbd-decoder.c:446:1: warning: data definition has no type or storage class
drivers/media/rc/ir-mce_kbd-decoder.c:446:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/media/rc/ir-mce_kbd-decoder.c:446:16: warning: function declaration isn't a prototype
drivers/media/rc/ir-mce_kbd-decoder.c:447:15: error: expected declaration specifiers or '...' before string constant
drivers/media/rc/ir-mce_kbd-decoder.c:447:1: warning: data definition has no type or storage class
drivers/media/rc/ir-mce_kbd-decoder.c:447:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/media/rc/ir-mce_kbd-decoder.c:447:15: warning: function declaration isn't a prototype
drivers/media/rc/ir-mce_kbd-decoder.c:448:20: error: expected declaration specifiers or '...' before string constant
drivers/media/rc/ir-mce_kbd-decoder.c:448:1: warning: data definition has no type or storage class
drivers/media/rc/ir-mce_kbd-decoder.c:448:1: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/media/rc/ir-mce_kbd-decoder.c:448:20: warning: function declaration isn't a prototype

Another interaction with the v4l-dvb tree.  Mauro, this patch could be
added to your tree as well:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 15:39:51 +1000
Subject: [PATCH] ir-mce_kbd-decoder: include module.h for its facilities

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/media/rc/ir-mce_kbd-decoder.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index fe96e54..3784ebf 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -14,6 +14,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
+#include <linux/module.h>
 
 #include "rc-core-priv.h"
 
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
