Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1CKNRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:17:54 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:36887 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1CKNRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:17:50 -0500
X-IronPort-AV: E=Sophos;i="4.62,303,1297036800"; 
   d="scan'208";a="4744568"
Date: Fri, 11 Mar 2011 13:17:23 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>
Subject: [GIT PULL tip/x86/mm] xen/x86 fixes
Message-ID: <alpine.DEB.2.00.1103111201470.2968@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
recently we had a couple of long discussions with Yinghai about boot
crashes on xen, related to pagetable initialization.
As a result we came up with three patches, two of them fix the first [1]
boot crash and provide a nice cleanup on native:


Stefano Stabellini (1):
      xen: set max_pfn_mapped to the last pfn mapped
Yinghai Lu (1):
      x86: Cleanup highmap after brk is concluded


The third is a xen patch that fixes the other boot crash [2], indirectly
caused by the new initial kernel pagetable allocation strategy:


Stefano Stabellini (1):
      xen: update mask_rw_pte after kernel page tables init changes


I have put together a branch with these three patches, based on
tip/x86/mm:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-tip-fixes

Could you please pull from it?


[1] https://lkml.org/lkml/2011/1/31/232
[2] https://lkml.org/lkml/2011/3/1/281 

The list of commits with a diffstat follows:

Stefano Stabellini (2):
      xen: set max_pfn_mapped to the last pfn mapped
      xen: update mask_rw_pte after kernel page tables init changes

Yinghai Lu (1):
      x86: Cleanup highmap after brk is concluded

 arch/x86/kernel/head64.c |    3 ---
 arch/x86/kernel/setup.c  |   25 +++----------------------
 arch/x86/mm/init_64.c    |   11 ++++++-----
 arch/x86/xen/mmu.c       |   21 ++++++++++++---------
 4 files changed, 21 insertions(+), 39 deletions(-)

Thanks,

Stefano
