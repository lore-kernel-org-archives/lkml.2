Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2H2TFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 15:05:08 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:47874
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754572Ab2H2TFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 15:05:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275dhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9J6BA-02-15Y-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V5 0/6] x86: Create direct mappings for E820_RAM only
Date: Wed, 29 Aug 2012 14:04:00 -0500
Message-ID: <1346267046-6724-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 5th revision of the patchset, which aims to create direct
mappings only for E820_RAM memory ranges. The problem description and
justification can be found in patch 4/6.

Previous discussion history can be found in the following threads:

* https://lkml.org/lkml/2012/8/24/474
* https://lkml.org/lkml/2012/8/22/680
* https://lkml.org/lkml/2012/8/13/512
* https://lkml.org/lkml/2012/8/9/536
* https://lkml.org/lkml/2011/10/20/323

Jacob Shin (4):
  x86/mm: find_early_table_space based on memory ranges that are being
    mapped
  x86: Only direct map addresses that are marked as E820_RAM
  x86: Fixup code testing if a pfn is direct mapped
  x86: if kernel .text .data .bss are not marked as E820_RAM, complain
    and fix

Yinghai Lu (2):
  x86, mm: Add page_size_mask()
  x86, mm: Split out split_mem_range

 arch/x86/include/asm/page_types.h |    9 +++
 arch/x86/include/asm/pgtable.h    |    1 +
 arch/x86/kernel/cpu/amd.c         |    6 +-
 arch/x86/kernel/setup.c           |  115 ++++++++++++++++++++++----
 arch/x86/mm/init.c                |  162 ++++++++++++++++++++-----------------
 arch/x86/mm/init_64.c             |    6 +-
 arch/x86/platform/efi/efi.c       |    8 +-
 7 files changed, 207 insertions(+), 100 deletions(-)

-- 
1.7.9.5


