Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab1EBRWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:22:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62355 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1EBRWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:22:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        yinghai@kernel.org, hpa@zytor.com
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] Two patches fixing regression introduced by 'x86-64, mm: Put early page table high'
Date: Mon,  2 May 2011 13:22:20 -0400
Message-Id: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DBEE861.0064:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a couple of days I thinking to ask Linus to pull this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-for-rc5

Which as two fixes that fix a bootup (Linux can't boot under Xen
at all) regression introduced by "x86-64, mm: Put early page table high"
(git commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e). Stefano
and Yinghai have been working on patches fixing this regression
when the patch was still in x86/mm-core before the 2.6.39 merge window openned.

But we haven't come up with an acceptable general solution yet, so this
patchset provides a workaround for the problem. Peter, Yinghai - what would be
the best forum/email/conference to hammer out a general solution for this?

Currently, there are couple of ways of fixing this:
 - use pvops hooks: http://marc.info/?i=1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com
 - have a workaround in Xen MMU's early bootup code (which is what these
   two patches to this email have).
 - or remove the patch introducing the regression altogether.

Foremost important is to fix the regression, and attached patches 
achieve that. I want to remove this workaround patch when we
hammer out more appropriate semantics for the page table creation - but
that will take some time and the runway to do that in 2.6.39 is gone.

Konrad Rzeszutek Wilk (1):
      xen/mmu: Add workaround "x86-64, mm: Put early page table high"

Stefano Stabellini (1):
      xen: mask_rw_pte mark RO all pagetable pages up to pgt_buf_top

 arch/x86/xen/mmu.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 124 insertions(+), 1 deletions(-)
