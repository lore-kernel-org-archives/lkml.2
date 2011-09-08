Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1IHXOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:14:25 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:61977 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab1IHXOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:14:12 -0400
X-IronPort-AV: E=Sophos;i="4.68,351,1312156800"; 
   d="scan'208";a="7684205"
Date: Thu, 8 Sep 2011 19:32:09 +0100
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH v4 0/2] xen: modify kernel mappings corresponding to granted
 pages
Message-ID: <alpine.DEB.2.00.1109081357000.12963@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is the forth version of the patch "xen: modify kernel mappings
corresponding to granted pages":

changes to v3:

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
 arch/x86/xen/p2m.c                  |   68 +++++++++++++++++++++++++++++------
 drivers/block/xen-blkback/blkback.c |    2 +-
 drivers/xen/balloon.c               |   12 ++++--
 drivers/xen/gntdev.c                |   29 ++++++++++++++-
 drivers/xen/grant-table.c           |    6 ++--
 include/xen/balloon.h               |    3 +-
 include/xen/grant_table.h           |    1 +
 8 files changed, 103 insertions(+), 23 deletions(-)


A git branch with the two patches on top of Linux 3.1 rc4 is available
here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.1-rc4-kernel_mappings_4

Cheers,

Stefano
