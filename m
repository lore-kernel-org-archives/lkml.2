Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab0KQCdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:33:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51889 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606Ab0KQCdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:33:46 -0500
Date: Wed, 17 Nov 2010 13:33:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the cleancache tree with the bkl-config
 tree
Message-Id: <20101117133343.3d75d053.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Today's linux-next merge of the cleancache tree got a conflict in
fs/ocfs2/super.c between commit cdbe83a95ae7c7a8762c10567a2c5d08cfc1cc4d
("BKL: remove extraneous #include <smp_lock.h>") from the bkl-config tree
and commit 91bf812da0c4f2efd0883fe02dc057853de731b1 ("ocfs2: add
cleancache support") from the cleancache tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ocfs2/super.c
index cfeab7c,e3f0a4e..0000000
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@@ -41,6 -41,8 +41,7 @@@
  #include <linux/mount.h>
  #include <linux/seq_file.h>
  #include <linux/quotaops.h>
 -#include <linux/smp_lock.h>
+ #include <linux/cleancache.h>
  
  #define MLOG_MASK_PREFIX ML_SUPER
  #include <cluster/masklog.h>
