Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab1ELX5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:57:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64776 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905Ab1ELX5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:57:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        martin.petersen@oracle.com, daniel.stodden@citrix.com, axboe@kernel.dk,
        chris.mason@oracle.com
Cc: hare@suse.de, JBeulich@novell.com, hch@infradead.org,
        xen-devel@lists.xensource.com, Ian.Campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, jeremy@goop.org
Subject: [PATCH v3.2] xen block backend.
Date: Thu, 12 May 2011 19:56:18 -0400
Message-Id: <1305244579-2830-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DCC73BD.0041:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch implements the Xen block backend driver for
upstream Linux. This is the host side counterpart to the frontend driver
in drivers/block/xen-blkfront.c. The PV protocol is also implemented by
frontend drivers in other OSes too, such as the BSDs and even Windows.

Changelog since posting:
[v3.1: https://lkml.org/lkml/2011/5/5/221]
 - added Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
 - fleshed out Kconfig
 - unified printk to use pr_* variant
 - converted spaces to tabs on structs.
 - updated comments to use proper style
 - prefixed structs with 'xen' and dropped typedefs.
 - fixed misspellings
 - moved include/xen/blkif.h in common.h
[v3: https://lkml.org/lkml/2011/4/20/403]
 - dropped 'feature-barrier' support
 - added 'feature-flush-cache' support
 - tested w/ NetBSD unstable, SLES11, RHEL5, 2.6.36, 2.6.39-rc6 guests to check
   for barrier/flush issues.
 - fixed write performance issues
 - ran benchmark numbers (http://thread.gmane.org/gmane.linux.kernel/1129246)

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

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git for-jens/xen-blkback-v3.2

NOTE: that this driver depends on couple of fixes to the Xen backend
subsystem. Those are available in devel/backend.base.v3 branch and are
intended for the 2.6.40 merge window.

 drivers/block/Kconfig               |   21 +
 drivers/block/Makefile              |    1 +
 drivers/block/xen-blkback/Makefile  |    3 +
 drivers/block/xen-blkback/blkback.c |  822 +++++++++++++++++++++++++++++++++++
 drivers/block/xen-blkback/common.h  |  233 ++++++++++
 drivers/block/xen-blkback/xenbus.c  |  768 ++++++++++++++++++++++++++++++++
 6 files changed, 1848 insertions(+), 0 deletions(-)
