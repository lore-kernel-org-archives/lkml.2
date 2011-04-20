Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1DTVF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:05:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19068 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1DTVF5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 20 Apr 2011 17:05:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, konrad@kernel.org
Subject: [PATCH v3] xen block backend. 
Date: Wed, 20 Apr 2011 17:05:42 -0400
Message-Id: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DAF4AAF.00A7:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch implements the Xen block backend driver for
upstream Linux. This is the host side counterpart to the frontend driver
in drivers/block/xen-blkfront.c. The PV protocol is also implemented by
frontend drivers in other OSes too, such as the BSDs and even Windows.

This driver has a long history as an out of tree driver but I am
submitting it here as a single monolithic patch to aid review. Once it
has been reviewed and is considered suitable for merging can we perhaps
consider merging the equivalent git branch which maintains much of
history?

The patch is based on the driver from the xen.git pvops kernel tree but
has been put through the checkpatch.pl wringer plus several manual
cleanup passes. It has also been moved from drivers/xen/blkback to
drivers/block/xen-blback.

The git tree of the broken out driver is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-blkback-v3

Note that this driver depends on couple of fixes to the Xen backend
subsystem. Those are available in devel/backend.base.v3 branch and are
intended for the 2.6.40 merge window.

 drivers/block/Kconfig               |    8 +
 drivers/block/Makefile              |    1 +
 drivers/block/xen-blkback/Makefile  |    3 +
 drivers/block/xen-blkback/blkback.c |  828 +++++++++++++++++++++++++++++++++++
 drivers/block/xen-blkback/common.h  |  128 ++++++
 drivers/block/xen-blkback/xenbus.c  |  764 ++++++++++++++++++++++++++++++++
 include/xen/blkif.h                 |  122 +++++
 7 files changed, 1854 insertions(+), 0 deletions(-)
