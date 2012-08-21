Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab2HUPP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:15:57 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27814 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2HUPPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:15:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,802,1336348800"; 
   d="scan'208";a="14109700"
From: Attilio Rao <attilio.rao@citrix.com>
To: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <hpa@zytor.com>,
        <tglx@linutronix.de>, <x86@kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>
CC: <konrad.wilk@oracle.com>, Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v3 0/2] XEN/X86: Document pagetable_reserve PVOPS and enforce a better semantic
Date: Tue, 21 Aug 2012 16:02:24 +0100
Message-ID: <1345561346-6781-1-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When looking for documenting the pagetable_reserve PVOPS, I realized that it
assumes start == pgt_buf_start. I think this is not semantically right
(even if with the current code this should not be a problem in practice) and
what we really want is to extend the logic in order to do the RO -> RW
convertion also for the range [pgt_buf_start, start).
This patch then implements this missing conversion, adding some smaller
cleanups and finally provides documentation for the PVOPS.
Please look at 2/2 for more details on how the comment is structured.
If we get this right we will have a reference to be used later on for others
PVOPS.

The difference with v1 is that sh_start local variable in
xen_mapping_pagetable_reserve() is renamed as begin. Also, the commit messages
have been tweaked.

The difference with v2 is that compiling warnings for x86_32 are fixed
about the usage of wrong format strings for panic() and pr_debug(). Also,
the range printing format has been unified and PFN_PHYS() members are
casted to u64 on printing, to remain consistent (which is basically
what also lib/swiotlb.c does.

Attilio Rao (2):
  XEN/X86: Improve semantic support for pagetable_reserve PVOPS
  XEN: Document the semantic of the pagetable_reserve PVOPS

 arch/x86/include/asm/x86_init.h |   19 +++++++++++++++++--
 arch/x86/mm/init.c              |    4 ++++
 arch/x86/xen/mmu.c              |   22 ++++++++++++++++++++--
 3 files changed, 41 insertions(+), 4 deletions(-)

-- 
1.7.2.5

