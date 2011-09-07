Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1IGQaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:30:05 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:10380 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1IGQaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:30:03 -0400
X-IronPort-AV: E=Sophos;i="4.68,346,1312156800"; 
   d="scan'208";a="7658338"
Date: Wed, 7 Sep 2011 17:38:09 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>
Subject: [PATCH v3 0/2] xen: modify kernel mappings corresponding to granted
 pages
Message-ID: <alpine.DEB.2.00.1109071723470.12963@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is the third version of the patch "xen: modify kernel mappings
corresponding to granted pages".
Compared to the latest version, following Jeremy's suggestion, I dropped
support for highmem pages. That made the code much simpler, therefore I
folded the multicall patch in the main patch because it didn't make much
sense to keep them separate anymore.
I modified gntdev to use lowmem pages only, so that we are always going
to be able to successfully modify the kernel mappings directly in the m2p
override.
In order to do that I extended the alloc_xenballooned_pages interface
with an highmem parameter that allows the caller to explicitly request
for highmem or lowmem pages.


Shortlog and diffstat follow:

Stefano Stabellini (2):
      xen: add an "highmem" parameter to alloc_xenballooned_pages
      xen: modify kernel mappings corresponding to granted pages

 arch/x86/include/asm/xen/page.h |    5 ++-
 arch/x86/xen/p2m.c              |   67 ++++++++++++++++++++++++++++++++------
 drivers/xen/balloon.c           |   12 +++++--
 drivers/xen/gntdev.c            |   29 +++++++++++++++-
 drivers/xen/grant-table.c       |    4 +-
 include/xen/balloon.h           |    3 +-
 include/xen/grant_table.h       |    1 +
 7 files changed, 100 insertions(+), 21 deletions(-)


A git branch with the two patches on top of Linux 3.1 rc4 is available
here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.1-rc4-kernel_mappings_3

Cheers,

Stefano
