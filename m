Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab2BJVCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:02:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759047Ab2BJVCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:02:44 -0500
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        tony.luck@intel.com, seiji.aguchi@hds.com, ak@linux.intel.com,
        mjg@redhat.com, levinsasha928@gmail.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/2] x86, reboot: cleanup NMI and REBOOT_IRQ
Date: Fri, 10 Feb 2012 16:02:13 -0500
Message-Id: <1328907735-6226-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After dealing with pstore conversations about spin locks, I had an idea
to simplify the native_smp_stop_other_cpus() path by using both REBOOT_IRQ
and NMI instead of using either or.

I also cleaned up a WARN_ON splat from rescheduling.

Tested 10 panics on my core2 quad using 'echo c > /proc/sysrq-trigger' and
panic=10 on the commandline.  The machine panic'd and rebooted succesfully
all 10 times.  Though only the first time did I see the WARN_ON splat, the
other 9 times I couldn't duplicate it.

Don Zickus (2):
  x86, reboot: revert stop_other_cpus to using IRQ with NMI fallback
  x86, reschedule: check to see if system is shutting down

 arch/x86/kernel/smp.c |  104 +++++++++++++++++++++++--------------------------
 1 files changed, 49 insertions(+), 55 deletions(-)

-- 
1.7.7.6

