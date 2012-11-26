Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab2KZUgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:36:37 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38344 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab2KZUgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:36:35 -0500
Subject: [PATCH 0/5] Alter steal time reporting in KVM
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: riel@redhat.com, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, glommer@parallels.com, mingo@redhat.com
Date: Mon, 26 Nov 2012 14:36:24 -0600
Message-ID: <20121126203603.28840.38736.stgit@lambeau>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12112620-5816-0000-0000-0000058E684B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of where you have a system that is running in a
capped or overcommitted environment the user may see steal time
being reported in accounting tools such as top or vmstat.  This can
cause confusion for the end user.  To ease the confusion this patch set
adds the idea of consigned (expected steal) time.  The host will separate
the consigned time from the steal time.  The consignment limit passed to the
host will be the amount of steal time expected within a fixed period of
time.  Any other steal time accruing during that period will show as the
traditional steal time.

---

Michael Wolf (5):
      Alter the amount of steal time reported by the guest.
      Expand the steal time msr to also contain the consigned time.
      Add the code to send the consigned time from the host to the guest
      Add a timer to allow the separation of consigned from steal time.
      Add an ioctl to communicate the consign limit to the host.


 arch/x86/include/asm/kvm_host.h       |   11 +++++++
 arch/x86/include/asm/kvm_para.h       |    3 +-
 arch/x86/include/asm/paravirt.h       |    4 +--
 arch/x86/include/asm/paravirt_types.h |    2 +
 arch/x86/kernel/kvm.c                 |    8 ++---
 arch/x86/kernel/paravirt.c            |    4 +--
 arch/x86/kvm/x86.c                    |   50 ++++++++++++++++++++++++++++++++-
 fs/proc/stat.c                        |    9 +++++-
 include/linux/kernel_stat.h           |    2 +
 include/linux/kvm_host.h              |    2 +
 include/uapi/linux/kvm.h              |    2 +
 kernel/sched/core.c                   |   10 ++++++-
 kernel/sched/cputime.c                |   21 +++++++++++++-
 kernel/sched/sched.h                  |    2 +
 virt/kvm/kvm_main.c                   |    7 +++++
 15 files changed, 120 insertions(+), 17 deletions(-)

-- 
Signature

