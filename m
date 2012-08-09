Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2HIVYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:24:37 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:46818
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392Ab2HIVX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:23:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275dhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8IBEX-02-FMI-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 0/5] Only create direct mappings for E820_RAM regions
Date: Thu, 9 Aug 2012 16:23:04 -0500
Message-ID: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a revision of an earlier attempt, with suggestions and concernes
from previous conversation (https://lkml.org/lkml/2011/12/16/486) taken
into account.

The following patchset creates direct mappings only for E820_RAM regions
between 0 ~ max_low_pfn and 4GB ~ max_pfn. And leaves non-E820_RAM
unmapped.

Jacob Shin (5):
  x86: Only direct map addresses that are marked as E820_RAM
  x86: find_early_table_space based on memory ranges that are being
    mapped
  x86: Keep track of direct mapped pfn ranges
  x86: Fixup code testing if a pfn is direct mapped
  x86: Move enabling of PSE and PGE out of init_memory_mapping

 arch/x86/include/asm/page_types.h |    9 ++++
 arch/x86/kernel/amd_gart_64.c     |    4 +-
 arch/x86/kernel/cpu/amd.c         |    6 +--
 arch/x86/kernel/setup.c           |   97 ++++++++++++++++++++++++++++++++++---
 arch/x86/mm/init.c                |   67 ++++++++++++-------------
 arch/x86/mm/init_64.c             |    3 +-
 arch/x86/platform/efi/efi.c       |    8 +--
 arch/x86/platform/efi/efi_64.c    |    2 +
 8 files changed, 139 insertions(+), 57 deletions(-)

-- 
1.7.9.5


