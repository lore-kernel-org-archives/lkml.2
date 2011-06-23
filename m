Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab1FWDD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:03:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60584 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061Ab1FWDDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:03:24 -0400
Date: Thu, 23 Jun 2011 13:03:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anderson Briglia <anderson.briglia@openbossa.org>,
        Anderson Lizardo <anderson.lizardo@openbossa.org>,
        Bruna Moreira <bruna.moreira@openbossa.org>,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: build failure after merge of the wireless tree
Message-Id: <20110623130317.b3a6085e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

After merging the wireless tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/bluetooth/smp.c: In function 'smp_e':
net/bluetooth/smp.c:49:21: error: storage size of 'sg' isn't known
net/bluetooth/smp.c:67:2: error: implicit declaration of function 'sg_init_one'
net/bluetooth/smp.c:49:21: warning: unused variable 'sg'

Caused by commit d22ef0bc83c5 ("Bluetooth: Add LE SMP Cryptoolbox
functions").  Missing include file, presumably.  This batch has been in
the bluetooth tree since June 14, so it may have been exposed by the
removal of linux/mm.h from netdevice.h ...

I have added the following patch as a merge fix up for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 23 Jun 2011 12:58:55 +1000
Subject: [PATCH] Bluetooth: include scatterlist.h where needed

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/bluetooth/smp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 52e9ec2..a36f870 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -25,6 +25,7 @@
 #include <net/bluetooth/l2cap.h>
 #include <net/bluetooth/smp.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <crypto/b128ops.h>
 
 #define SMP_TIMEOUT 30000 /* 30 seconds */
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
