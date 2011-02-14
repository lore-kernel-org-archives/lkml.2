Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1BNT2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:28:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1BNT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:28:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=iDUFybsBwujGOGzZDDa9J+vOYhlfU4YKDGlfwqFsJcOxWOQ09uFUz2pcjy5yqVRt1U
         bE5ObyFi55NrpiizyADNXNy9fG3IERKfVoU/qQofqXXEjWimrAun8SR2FMMTt6RUXiBp
         XVHsopHAEeIaz95xwgdLEwqNEkQAhj0OMKwyA=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Subject: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA emulation
Date: Mon, 14 Feb 2011 20:28:28 +0100
Message-Id: <1297711715-3086-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

NUMA emulation is quite convoluted involving unnecessary mapping and
reverse mapping between apicids, PXMs, nodes and memory addresses.
This patchset tries to restore some sanity to the whole thing.

Tested on an opteron NUMA machine which can do both ACPI and AMD
configs.  All NUMA configs, emulations, !NUMA and UP work as expected.

This patchset is on top of tip/x86/numa[1] +
bring-sanity-to-NUMA-configuration patchset[2] and contains the
following 7 patches.

 0001-x86-64-NUMA-Trivial-changes-to-prepare-for-emulation.patch
 0002-x86-64-NUMA-Build-and-use-direct-emulated-nid-phys-n.patch
 0003-x86-64-NUMA-Make-emulation-code-build-numa_meminfo-a.patch
 0004-x86-64-NUMA-Wrap-node-ID-during-emulation.patch
 0005-x86-64-NUMA-Emulate-directly-from-numa_meminfo.patch
 0006-x86-64-NUMA-Unify-emulated-apicid-node-mapping-trans.patch
 0007-x86-64-NUMA-Unify-emulated-distance-mapping.patch

The patchset is available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify

Diffstat follows.

 arch/x86/include/asm/acpi.h    |    6 
 arch/x86/include/asm/amd_nb.h  |    4 
 arch/x86/include/asm/numa_64.h |    1 
 arch/x86/mm/amdtopology_64.c   |   47 ----
 arch/x86/mm/numa_64.c          |  429 ++++++++++++++++++-----------------------
 arch/x86/mm/srat_64.c          |   87 --------
 6 files changed, 197 insertions(+), 377 deletions(-)

Thanks.

--
tejun

[1] eff9073790e1286aa12bf1c65814d3e0132b12e1 (x86: Rename incorrectly
    named parameter of numa_cpu_node())
[2] http://thread.gmane.org/gmane.linux.kernel/1099256/
