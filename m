Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0ESS7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:59:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab0ESS7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:59:07 -0400
From: Thomas Renninger <trenn@suse.de>
To: trenn@suse.de, peterz@infradead.org
Cc: mike@android.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       menage@google.com, containers@lists.linux-foundation.org, mingo@elte.hu
Subject: scheduler: cleanup sched.c and extract cgroup_cpuaccount stuff into separate file
Date: Wed, 19 May 2010 20:58:57 +0200
Message-Id: <1274295539-7798-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1274264877.5605.10541.camel@twins>
References: <1274264877.5605.10541.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch should only be moving code.
To be able to access cpu_rq in sched.c:
raw_spin_lock_irq(&cpu_rq(cpu)->lock);

void unlock_runqueue(unsigned int cpu)
wrapper is added and kernel/sched.h created.

The locks and sched.h are removed again in the second
patch, this should be the only "real" change.
There atomic64_t is introduced in a per_cpu_ptr variable
to avoid the lock.
Not sure about allocating atomic64_t like that is
correct. Review is appreciated.
Both patches are compile tested on various archs and configs.

       Thomas


