Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab2GDLPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:15:31 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:37405 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2GDLPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:15:30 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336348800"; 
   d="scan'208";a="13364044"
Date: Wed, 4 Jul 2012 12:14:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH WIP 0/5] xen/arm: grant_table, blkfront and blkback
Message-ID: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series initializes the grant_table and xenbus on ARM.
It also get blkfront and blkback to compile and run properly.

With this patch series and the corresponding xen patch series applied, I
am able to boot a Linux domU with a root filesystem on a xen PV disk.


Stefano Stabellini (5):
      xen/arm: initialize grant_table on ARM
      xen/arm: set xen_platform_pci_unplug to XEN_UNPLUG_ALL
      xen/arm: implement alloc/free_xenballooned_pages with alloc_pages/kfree
      xen: allow privcmd for hvm guests
      xen/arm: compile blkfront and blkback

 arch/arm/include/asm/hypervisor.h    |    6 +++++
 arch/arm/xen/enlighten.c             |   39 +++++++++++++++++++++++++++++++++-
 drivers/block/xen-blkback/blkback.c  |    1 +
 drivers/block/xen-blkfront.c         |    1 +
 drivers/xen/grant-table.c            |    2 +-
 drivers/xen/xenfs/privcmd.c          |    7 ------
 include/xen/interface/hvm/params.h   |    4 ++-
 include/xen/interface/io/protocols.h |    3 ++
 8 files changed, 53 insertions(+), 10 deletions(-)


git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git xenarmv7-3

Cheers,

Stefano
