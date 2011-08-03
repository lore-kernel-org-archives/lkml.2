Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1HCDwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 23:52:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54336 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab1HCDv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 23:51:56 -0400
Date: Wed, 3 Aug 2011 13:51:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the moduleh tree with the
 staging.current tree
Message-Id: <20110803135150.249e34087e78caa2797d2b60@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/staging/dt3155v4l/dt3155v4l.c between commit dac95cb8cf40
("drivers/staging/dt3155v4l/dt3155v4l.c needs slab.h") from the
staging.current tree and commit 9e1049c45c01 ("staging: Add module.h to
drivers/staging users") from the moduleh tree.

Also note that commit 5c751107250f ("staging: fix implicit use of slab.h
in dt3155v4l/dt3155v4l.c") from the moduleh tree is a duplicate of the
above staging.current tree commit (with the include in a slightly
different spot.

I fixed it up (see below) anc can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/dt3155v4l/dt3155v4l.c
index 05aa41c,024390b..0000000
--- a/drivers/staging/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c
@@@ -21,8 -21,9 +21,9 @@@
  #include <linux/version.h>
  #include <linux/stringify.h>
  #include <linux/delay.h>
 -#include <linux/slab.h>
  #include <linux/kthread.h>
 +#include <linux/slab.h>
+ #include <linux/module.h>
  #include <media/v4l2-dev.h>
  #include <media/v4l2-ioctl.h>
  #include <media/videobuf2-dma-contig.h>
