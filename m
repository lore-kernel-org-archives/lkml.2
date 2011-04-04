Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1DDWYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:24:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab1DDWYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=a0ZAZzw+fp635t8wnbFqQMYBJ/zI/WbUGDwCHwR/10SNakoOWF8KEF/KVLXbC4bbZJ
         w1nQOAXYNhXz+Y1jOiXx+XbIktK4Hh74OxFZ9IJGvivaiBX2UCRA7SkCEZxaIQ18ZhFs
         66mDgqRE0Mo1k9uzpJAF+MfjX9FaIDFyFEdL8=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHSET tip:x86/mm] x86-32, NUMA: Clean up alloc_remap
Date: Tue,  5 Apr 2011 00:23:46 +0200
Message-Id: <1301955840-7246-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset cleans up remap allocator in preparation for 32/64bit
NUMA unification.  After the patchset, remap allocator initialization
is separate from the rest of NUMA initializaiton.  In the process,
several bugs are fixed and boot is made less verbose.

This patchset contains the following fourteen patches.  Please note
that x86/urgent needs to be pulled into x86/mm for 32bit NUMA to work
at all (765af22da8 "x86-32, NUMA: Fix ACPI NUMA init broken by recent
x86-64 change").

 0001-x86-32-NUMA-Fix-failure-condition-check-in-alloc_rem.patch
 0002-x86-32-NUMA-Align-pgdat-size-while-initializing-allo.patch
 0003-x86-32-NUMA-Remove-redundant-top-down-alloc-code-fro.patch
 0004-x86-32-NUMA-Reorganize-calculate_numa_remap_page.patch
 0005-x86-32-NUMA-Rename-node_kva-to-node_pa-in-init_alloc.patch
 0006-x86-32-NUMA-Make-size-in-init_aloc_remap-represent-b.patch
 0007-x86-32-NUMA-Calculate-remap-size-in-common-code.patch
 0008-x86-32-NUMA-Make-init_alloc_remap-less-panicky.patch
 0009-x86-32-NUMA-Move-lowmem-address-space-reservation-to.patch
 0010-x86-32-NUMA-Move-remapping-for-remap-allocator-into-.patch
 0011-x86-32-NUMA-Make-pgdat-allocation-use-alloc_remap.patch
 0012-x86-32-NUMA-Remove-now-useless-node_remap_offset.patch
 0013-x86-32-NUMA-Remove-redundant-node_remap_size.patch
 0014-x86-32-NUMA-Update-remap-allocator-comments.patch

The patchset is on top of the current x86/mm (64d21fc194) and
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cleanup-alloc_remap 

diffstat follows.

 arch/x86/include/asm/topology.h |    1 
 arch/x86/kernel/apic/numaq_32.c |    4 
 arch/x86/mm/numa_32.c           |  268 ++++++++++++++++------------------------
 arch/x86/mm/srat_32.c           |    1 
 4 files changed, 111 insertions(+), 163 deletions(-)

Thanks.

--
tejun
