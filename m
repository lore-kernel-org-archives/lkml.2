Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1ECMdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:33:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63423 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1ECMdX (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 3 May 2011 08:33:23 -0400
Date: Tue, 3 May 2011 08:33:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hpa@zytor.com, yinghai@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/bug-fixes-for-rc5 for 2.6.39-rc5.
Message-ID: <20110503123301.GA5385@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DBFF606.00DD:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please git pull

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-for-rc5

since git commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58
Linus Torvalds (1)
    Linux 2.6.39-rc5

The git pull contains two fixes that fix the last remaining issue Linux
2.6.39 not booting with Xen. This particular git pull fixes the bootup regression
introduced by "x86-64, mm: Put early page table high" (git commit
4b239f458c229de044d6905c2b0f9fe16ed9e01e). Stefano and Yinghai (author of the
regression) have been working on patches fixing this regression
when the patch was still in x86/mm-core before the 2.6.39 merge window openned.

But we haven't come up with an acceptable general solution yet, so this
patchset provides a workaround for the problem.

There are couple of ways of fixing this:
 - use pvops hooks: http://marc.info/?i=1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com
 - have a workaround in Xen MMU's early bootup code (which is what this
   git pull has).
 - or remove the patch introducing the regression altogether.

Foremost important is to fix the regression, and the patches in the GIT
pull achieve that. I want to remove this workaround patch when we
hammer out more appropriate semantics for the page table creation - but
that will take some time and the runway to do that in 2.6.39 is gone.

Hence asking for these two patches to be pulled.

Konrad Rzeszutek Wilk (1):
      xen/mmu: Add workaround "x86-64, mm: Put early page table high"

Stefano Stabellini (1):
      xen: mask_rw_pte mark RO all pagetable pages up to pgt_buf_top

 arch/x86/xen/mmu.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 124 insertions(+), 1 deletions(-)
