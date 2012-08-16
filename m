Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab2HPNMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:12:44 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:12138 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HPNMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:12:42 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336348800"; 
   d="scan'208";a="14040416"
From: Attilio Rao <attilio.rao@citrix.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v2 0/2] XEN/X86: Document pagetable_reserve PVOPS and enforce a better semantic
Date: Thu, 16 Aug 2012 13:59:34 +0100
Message-ID: <1345121976-11169-1-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <y>
References: <y>
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

Attilio Rao (2):
  XEN, X86: Improve semantic support for pagetable_reserve PVOPS
  Xen: Document the semantic of the pagetable_reserve PVOPS

 arch/x86/include/asm/x86_init.h |   19 +++++++++++++++++--
 arch/x86/mm/init.c              |    4 ++++
 arch/x86/xen/mmu.c              |   22 ++++++++++++++++++++--
 3 files changed, 41 insertions(+), 4 deletions(-)

-- 
1.7.2.5

