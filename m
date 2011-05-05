Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1EETKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:10:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18145 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1EETKP (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 5 May 2011 15:10:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        xen-devel@lists.xensource.com
Cc: daniel.stodden@citrix.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com
Subject: [PATCH] xen-blkfront patches for 2.6.40.
Date: Thu,  5 May 2011 14:55:18 -0400
Message-Id: <1304621721-22608-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DC2F610.0097:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am proposing these three patches for 2.6.40. 

 [PATCH 1/3] xen-blkfront: fix data size for xenbus_gather in blkfront_connect

fixes a bug, while these two:
 [PATCH 2/3] xen-blkfront: Provide for 'feature-flush-cache' the BLKIF_OP_WRITE_FLUSH_CACHE operation.
 [PATCH 3/3] xen-blkfront: Introduce BLKIF_OP_FLUSH_DISKCACHE support.

Provide the functionality to use the BLKIF_OP_WRITE_FLUSH_CACHE operation, which is
negotiated with the backend if the 'feature-flush-cache' is advertised. Currently there
are three OSes that advertise this flag: NetBSD 5.1 (and unstable), Linux
(devel/xen-blkback-v3.1), and Solaris.

I've tested it with success on NetBSD 5.1 Dom0, and with Linux v2.6.39-rc6 with
the devel/xen-blkback-v3.1 patches.

The git tree with these patches is:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/blkfront


 drivers/block/xen-blkfront.c     |   51 +++++++++++++++++++++++++++----------
 include/xen/interface/io/blkif.h |   13 +++++++++
 2 files changed, 50 insertions(+), 14 deletions(-)


Konrad Rzeszutek Wilk (2):
      xen-blkfront: Provide for 'feature-flush-cache' the BLKIF_OP_WRITE_FLUSH_CACHE operation.
      xen-blkfront: Introduce BLKIF_OP_FLUSH_DISKCACHE support.

Marek Marczykowski (1):
      xen-blkfront: fix data size for xenbus_gather in blkfront_connect

