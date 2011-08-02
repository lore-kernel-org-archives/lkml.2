Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab1HBH54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:57:56 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:57725 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1HBH5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:57:52 -0400
Date: Tue, 2 Aug 2011 09:57:35 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Fred Isaman <iisaman@citi.umich.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH] nfs: add missing prefetch.h include
Message-ID: <20110802075735.GA3466@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fix this compile error on s390:

  CC [M]  fs/nfs/blocklayout/blocklayout.o
fs/nfs/blocklayout/blocklayout.c: In function 'bl_end_io_read':
fs/nfs/blocklayout/blocklayout.c:201:4: error: implicit declaration of function 'prefetchw'

Introduced with 9549ec01 "pnfsblock: bl_read_pagelist".

Cc: Fred Isaman <iisaman@citi.umich.edu>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/nfs/blocklayout/blocklayout.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -36,6 +36,7 @@
 #include <linux/namei.h>
 #include <linux/bio.h>		/* struct bio */
 #include <linux/buffer_head.h>	/* various write calls */
+#include <linux/prefetch.h>
 
 #include "blocklayout.h"
 
