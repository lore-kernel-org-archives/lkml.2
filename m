Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1JKPZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:25:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab1JKPZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:25:40 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, seiji.aguchi@hds.com,
        vgoyal@redhat.com, mjg@redhat.com, tony.luck@intel.com,
        gong.chen@intel.com, satoru.moriya@hds.com, avi@redhat.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/3] Use NMI to stop cpus
Date: Tue, 11 Oct 2011 11:24:43 -0400
Message-Id: <1318346686-12349-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series attempts to use NMI to stop cpus instead of the
REBOOT_VECTOR irq.  The idea is to have a more robust and reliable
way to stop cpus when serializing things like the panic path.

More details in the changelogs.

Don Zickus (3):
  x86, reboot:  Use NMI instead of REBOOT_VECTOR to stop cpus
  x86, NMI: Add NMI IPI selftest
  x86, NMI: knob to disable using NMI IPIs to stop cpus

 Documentation/kernel-parameters.txt |    4 ++
 arch/x86/Kconfig.debug              |   12 ++++++
 arch/x86/include/asm/smp.h          |    1 +
 arch/x86/kernel/smp.c               |   71 ++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/smpboot.c           |   57 ++++++++++++++++++++++++++++
 5 files changed, 143 insertions(+), 2 deletions(-)

-- 
1.7.6.4

