Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1FFXSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:18:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:59648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1FFXSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:18:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,328,1304319600"; 
   d="scan'208";a="10283925"
Message-Id: <20110606231655.824641917@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 06 Jun 2011 16:16:55 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com
Subject: [patch 0/2] enhance stop machine infrastructure for MTRR rendezvous sequence
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

thanks,
suresh


