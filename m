Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab1FXQB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:01:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab1FXQB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:01:57 -0400
Date: Fri, 24 Jun 2011 12:01:43 -0400
From: Don Zickus <dzickus@redhat.com>
To: peterz@redhat.com, eranian@google.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: x86, perf, pmu: make reserve_ds_buffers() allocate memory dynamically
Message-ID: <20110624160143.GA29969@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Some kdump folks noticed that on large machines (say 80 cpu threads), the
kernel reserved a good chunk of memory in the kdump kernel with the call
to reserve_ds_buffers(). About 64k per cpu.

Normally the kdump kernel boots with maxcpus=1 to limit the amount of
processing and memory usage it needs.  However, with reserve_ds_buffers()
it seems to allocate a giant chunk of memory due to its use of
for_each_possible_cpu().

I was wondering if it was possible to move some of that allocation to the
cpu_prepare/cpu_starting routines and allocate during a cpu hotplug event.
I am not sure if some of this allocation is on a per cpu basis (which
includes multiple cores) or if there is some sort of other restriction
that required the code to be statically allocated at boot time.

Thanks,
Don

