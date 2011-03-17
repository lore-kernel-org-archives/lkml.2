Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1CQRuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:50:55 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:25706 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab1CQRuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:50:52 -0400
X-IronPort-AV: E=Sophos;i="4.63,200,1299456000"; 
   d="scan'208";a="4847380"
Date: Thu, 17 Mar 2011 17:50:20 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL tip/x86/mm] [v2] xen/x86 fixes
Message-ID: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have a branch with two critical fixes for Xen and one cleanup for
arch/x86 (on which one of the two bug fixes depends upon); the branch is
based on tip/x86/mm.
I issued another git pull request a little while ago but a bug was found
that prevented a machine to boot with these three patches applied. The
bug turned out to be a bug in the SP5100 TCO WatchDog Timer Driver and
it is fixed by this patch:

https://lkml.org/lkml/2011/3/16/375

So I am now kindly asking you again to pull the branch:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-tip-fixes


The original threads were these patches were discussed are the
following:

https://lkml.org/lkml/2011/1/31/232
https://lkml.org/lkml/2011/3/1/281 

Please note that without these commits the current 2.6.39-rc0 crashes
reliably on Xen on every boot.

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
