Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1I2K4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:56:52 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:36072 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1I2K4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:56:51 -0400
X-IronPort-AV: E=Sophos;i="4.68,460,1312156800"; 
   d="scan'208";a="8124449"
Date: Thu, 29 Sep 2011 11:56:27 +0100
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH v5 0/2] xen: modify kernel mappings corresponding to granted
 pages
Message-ID: <alpine.DEB.2.00.1109291148340.3519@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is the fifth version of the patch "xen: modify kernel mappings
corresponding to granted pages":


changes to v4:

- add many more comments to the code;

- fix some code style issues;

- use set_page_private/page_private macros;

- compare with GNTST_general_error rather than -1;

- BUG in case map->pages are highmem;


Changes to v3:

- move the xen_mc_entry call in m2p_remove_override after the
xen_mc_flush call;

- use false rather than 0 as a parameter to alloc_xenballooned_pages;

- update the m2p_add_override call in blkback.c, following the new
interface;

- fix few code style issues.


Changes to v2:

- drop highmem support;

- fold the multicall patch into the main patch;

- add another patch to extend the alloc_xenballooned_pages interface
with an highmem parameter that allows the caller to explicitly request
for highmem or lowmem pages;

- modify gntdev to use lowmem pages only thanks to the new
alloc_xenballooned_pages interface.


Shortlog and diffstat follow:

Stefano Stabellini (2):
      xen: add an "highmem" parameter to alloc_xenballooned_pages
      xen: modify kernel mappings corresponding to granted pages

 arch/x86/include/asm/xen/page.h     |    5 ++-
 arch/x86/xen/p2m.c                  |   79 ++++++++++++++++++++++++++++++-----
 drivers/block/xen-blkback/blkback.c |    2 +-
 drivers/xen/balloon.c               |   12 ++++--
 drivers/xen/gntdev.c                |   34 ++++++++++++++-
 drivers/xen/grant-table.c           |    6 +-
 include/xen/balloon.h               |    5 +-
 include/xen/grant_table.h           |    1 +
 8 files changed, 120 insertions(+), 24 deletions(-)


A git branch with the two patches on top of Konrad's "Xen MMU fixes for
3.2" patch series
(1316831299-4144-1-git-send-email-konrad.wilk@oracle.com) on top of
Linux 3.1 rc4 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.1-rc4-kernel_mappings_5

Cheers,

Stefano
