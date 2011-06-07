Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1FGUQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:16:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:34473 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab1FGUQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:16:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,334,1304319600"; 
   d="scan'208";a="15159302"
Message-Id: <20110607201411.791585562@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 07 Jun 2011 13:14:11 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com
Subject: [patch v2 0/2] enhance stop machine infrastructure for MTRR rendezvous sequence
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch enhance the stop machine infrastructure so that we
can call __stop_machine() from the cpu hotplug path, where the calling
cpu is not yet online. We do allow this for already for !CONFIG_SMP. So this
patch brings the CONFIG_SMP behavior inline with !CONFIG_SMP

Second patch uses the enhanced __stop_machine() to implement the x86 MTRR
init rendezvous sequence and thus remove the duplicate implementation
of stop machine using stop_one_cpu_nowait(). This duplicate implementation
of stop machine can potentially lead to deadlock if there is a parallel
system wide rendezvous using __stop_machine().

Both these address one of the deadlocks mentioned in the
https://bugzilla.novell.com/show_bug.cgi?id=672008

Changes from v1:
* Use stop_cpu thread enabled status to find out if the cpu is online/offline,
  instead of using cpu_online(smp_processor_id()). This avoids a false
  positive of using smp_processor_id() from preemptible section.

thanks,
suresh

