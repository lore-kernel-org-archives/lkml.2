Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1INCuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 22:50:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58644 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab1INCuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 22:50:15 -0400
Date: Wed, 14 Sep 2011 12:50:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Einar Lueck <elelueck@de.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the net tree with the s390 tree
Message-Id: <20110914125008.6c7e2bd132ad8f473e7524ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/s390/cio/qdio_main.c between commit 003184781fea ("[S390] s390:
fix mismatch in summation of I/O IRQ statistics") from the s390 tree and
commit 104ea556ee7f ("qdio: support asynchronous delivery of storage
blocks") from the net tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/s390/cio/qdio_main.c
index a122c1c,9a12228..0000000
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@@ -14,6 -14,8 +14,7 @@@
  #include <linux/timer.h>
  #include <linux/delay.h>
  #include <linux/gfp.h>
+ #include <linux/io.h>
 -#include <linux/kernel_stat.h>
  #include <linux/atomic.h>
  #include <asm/debug.h>
  #include <asm/qdio.h>
