Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab2BMU2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:28:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005Ab2BMU2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:28:01 -0500
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        tony.luck@intel.com, seiji.aguchi@hds.com, ak@linux.intel.com,
        mjg@redhat.com, levinsasha928@gmail.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/2 v2] x86, reboot: cleanup NMI and REBOOT_IRQ
Date: Mon, 13 Feb 2012 15:27:38 -0500
Message-Id: <1329164860-668-1-git-send-email-dzickus@redhat.com>
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

 arch/x86/kernel/smp.c |  103 +++++++++++++++++++++++--------------------------
 1 files changed, 48 insertions(+), 55 deletions(-)

-- 
1.7.7.6

