Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1G0DU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:20:57 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:58521 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518Ab1G0DU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:20:56 -0400
X-AuditID: 12074424-b7b0fae000000a08-06-4e2f842d92da
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/5] Collected vdso/vsyscall fixes for 3.1
Date: Tue, 26 Jul 2011 23:20:34 -0400
Message-Id: <cover.1311736366.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsUixG6nrqvbou9nsHcHu0XflaPsFo/mPWK1
	mLpsLqvFssVPGS0u75rDZrH87Dw2ix8bHrNa3Jvynt2Bw2PnrLvsHpsvrmby2LSqk81j8o3l
	jB7b+3axe3x8eovF4/MmuQD2KC6blNSczLLUIn27BK6MDauDCj5yVfSviGhgfMLexcjJISFg
	IjH30xFWCFtM4sK99WxdjFwcQgL7GCWWblsElhAS2MAosWxtEkTiGZPEwokbmUESbAIqEh1L
	HzCB2CICThKtEz4ygRQxCzxjlNh09AxYkbCAlcTfbWvAJrEIqEq87HzNBmLzCuhLPL45jwli
	tZzEkcvPmSYw8ixgZFjFKJuSW6Wbm5iZU5yarFucnJiXl1qka66Xm1mil5pSuokRHGouKjsY
	mw8pHWIU4GBU4uHdFKnvJ8SaWFZcmXuIUZKDSUmUN6MZKMSXlJ9SmZFYnBFfVJqTWnyIUYKD
	WUmEd8d/PT8h3pTEyqrUonyYlDQHi5I4b6n3f18hgfTEktTs1NSC1CKYrAwHh5IEbxjIUMGi
	1PTUirTMnBKENBMHJ8hwHqDh3iA1vMUFibnFmekQ+VOMilLivNkgCQGQREZpHlwvLBW8YhQH
	ekWYNwSkigeYRuC6XwENZgK5WgdscEkiQkqqgbHp7m2m6x6nzHjT6vXsH/+2bPokKDHhRZKp
	xlONlfor6o4zr0/47bm9pert5UVWDPoVRZmxeTdUnALeMbrlN9ze/0T4Jq+ev4OIp9+Mu8tX
	+c9MvRH94PhsyaVRlaeXHTzC4/n0zfPjjQdZn2Zt6GzPXXKHYeXMXT8KG/SdedRULxet/ftr
	3i4lluKMREMt5qLiRADtJsRn4AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes various problems that cropped up with the vdso patches.

 - Patch 1 fixes an information leak to userspace.
 - Patches 2 and 3 fix the kernel build on gold.
 - Patches 4 and 5 fix Xen (I hope).

Konrad, could you could test these on Xen and run 'test_vsyscall test' [1]?
I don't have a usable Xen setup.

Also, I'd appreciate a review of patches 4 and 5 from some Xen/paravirt
people.

[1] https://gitorious.org/linux-test-utils/linux-clock-tests


Andy Lutomirski (5):
  x86-64: Pad vDSO to a page boundary
  x86-64: Move the "user" vsyscall segment out of the data segment.
  x86-64: Work around gold bug 13023
  x86-64/xen: Enable the vvar mapping
  x86-64: Add user_64bit_mode paravirt op

 arch/x86/include/asm/desc.h           |    4 +-
 arch/x86/include/asm/paravirt_types.h |    6 ++++
 arch/x86/include/asm/ptrace.h         |   19 +++++++++++++
 arch/x86/kernel/paravirt.c            |    4 +++
 arch/x86/kernel/step.c                |    2 +-
 arch/x86/kernel/vmlinux.lds.S         |   46 ++++++++++++++++++---------------
 arch/x86/kernel/vsyscall_64.c         |    6 +---
 arch/x86/mm/fault.c                   |    2 +-
 arch/x86/vdso/vdso.S                  |    1 +
 arch/x86/xen/enlighten.c              |    1 +
 arch/x86/xen/mmu.c                    |    4 ++-
 11 files changed, 64 insertions(+), 31 deletions(-)

-- 
1.7.6

