Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289Ab2FHPeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:34:00 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1684 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757781Ab2FHPd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:33:59 -0400
Message-ID: <1339169631.30984.2.camel@x61.thuisdomein>
Subject: [PATCH] Remove lib/mpi/generic_mpi-asm-defs.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 17:33:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 15:33:51.0998 (UTC) FILETIME=[1B5621E0:01CD458C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header got added by commit 7e8dec918ef8e0f68b4937c3c50fa57002077a4d
("crypto: GnuPG based MPI lib - additional sources (part 4)"). Nothing
includes it.

The sole named constant it defines is BYTES_PER_MPI_LIMB. That named
constant is already provided by <linux/mpi.h> (which is made available
to the files in lib/mpi via mpi-internal.h). In this header that define
depends on the undefined macro SIZEOF_UNSIGNED_LONG.

So this header is unused, unneeded and broken. It can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This patch is, once again, tested only with "git grep".

 lib/mpi/generic_mpi-asm-defs.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)
 delete mode 100644 lib/mpi/generic_mpi-asm-defs.h

diff --git a/lib/mpi/generic_mpi-asm-defs.h b/lib/mpi/generic_mpi-asm-defs.h
deleted file mode 100644
index 047d1f5..0000000
--- a/lib/mpi/generic_mpi-asm-defs.h
+++ /dev/null
@@ -1,4 +0,0 @@
-/* This file defines some basic constants for the MPI machinery.  We
- * need to define the types on a per-CPU basis, so it is done with
- * this file here.  */
-#define BYTES_PER_MPI_LIMB  (SIZEOF_UNSIGNED_LONG)
-- 
1.7.7.6

