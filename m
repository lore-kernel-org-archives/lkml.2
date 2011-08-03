Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1HCNcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:32:19 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:59062 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208Ab1HCNcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:32:12 -0400
X-AuditID: 12074423-b7b31ae000000a3c-bf-4e394ddf6ac1
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 0/6] Collected vdso/vsyscall fixes for 3.1
Date: Wed,  3 Aug 2011 09:31:48 -0400
Message-Id: <cover.1312378163.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsUixCmqrXvf19LP4Pk/YYu+K0fZLR7Ne8Rq
	MXXZXFaLZYufMlpc3jWHzWL52XlsFj82PGa1uDflPbsDh8fOWXfZPTZfXM3ksWlVJ5vH5BvL
	GT229+1i9/j49BaLx+dNcgHsUVw2Kak5mWWpRfp2CVwZa+ZuYy94w1PxYNt7pgbGbZxdjJwc
	EgImEl9XH2WFsMUkLtxbz9bFyMUhJLCPUeLel35GkISQwHpGiat9XBCJp0wSU5b8ZQFJsAmo
	SHQsfcAEYosIOEm0TvjIBFLELPCMUWLT0TPMIAlhAVuJleueghWxCKhKPG24AGbzCuhLLJvW
	ywyxWk7iyOXnTBMYeRYwMqxilE3JrdLNTczMKU5N1i1OTszLSy3SNdPLzSzRS00p3cQICjd2
	F+UdjH8OKh1iFOBgVOLhZZS38BNiTSwrrsw9xCjJwaQkyrvcy9JPiC8pP6UyI7E4I76oNCe1
	+BCjBAezkghvOy9QjjclsbIqtSgfJiXNwaIkzpvr/d9XSCA9sSQ1OzW1ILUIJivDwaEkwcsP
	jCshwaLU9NSKtMycEoQ0EwcnyHAeoOE2IDW8xQWJucWZ6RD5U4yKUuK8hiAJAZBERmkeXC8s
	HbxiFAd6RZiXAaSKB5hK4LpfAQ1mAhr8/70FyOCSRISUVAPjCYXdV22yNebvOZC1Olumcgaf
	4E798rRVi/YYM/afXRX5pbda3q1LrSvm6O7qnAnqu1u493EZTj904GB28Tup60Zr9jGsqJm7
	X0lNgv+r39zUH4Xrk2wv5mhyXRc6ts+qXXPjC7PNJ9aJ9Ds1b+PzfSloLXR5qvq0QwILDD4X
	n/TPtCxyTelTYinOSDTUYi4qTgQAu8lryuICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes various problems that cropped up with the vdso patches.

 - Patch 1 fixes an information leak to userspace.
 - Patches 2 and 3 fix the kernel build on gold.
 - Patches 4 and 5 fix Xen (I hope).
 - Patch 6 (optional) adds a trace event to vsyscall emulation.  It will
   make it easier to handle performance regression reports :)

[1] https://gitorious.org/linux-test-utils/linux-clock-tests

Changes from v1:
 - Improve changelog message for "x86-64/xen: Enable the vvar mapping"
 - Fix 32-bit build.
 - Add patch 6.

Andy Lutomirski (6):
  x86-64: Pad vDSO to a page boundary
  x86-64: Move the "user" vsyscall segment out of the data segment.
  x86-64: Work around gold bug 13023
  x86-64/xen: Enable the vvar mapping
  x86-64: Add user_64bit_mode paravirt op
  x86-64: Add vsyscall:emulate_vsyscall trace event

 arch/x86/include/asm/desc.h           |    4 +-
 arch/x86/include/asm/paravirt_types.h |    6 ++++
 arch/x86/include/asm/ptrace.h         |   19 +++++++++++++
 arch/x86/kernel/paravirt.c            |    4 +++
 arch/x86/kernel/step.c                |    2 +-
 arch/x86/kernel/vmlinux.lds.S         |   46 ++++++++++++++++++---------------
 arch/x86/kernel/vsyscall_64.c         |   12 +++++---
 arch/x86/kernel/vsyscall_trace.h      |   29 ++++++++++++++++++++
 arch/x86/mm/fault.c                   |    2 +-
 arch/x86/vdso/vdso.S                  |    1 +
 arch/x86/xen/enlighten.c              |    4 +++
 arch/x86/xen/mmu.c                    |    4 ++-
 12 files changed, 102 insertions(+), 31 deletions(-)
 create mode 100644 arch/x86/kernel/vsyscall_trace.h

-- 
1.7.6

