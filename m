Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1LMHGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:06:42 -0500
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:61835 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1LMHGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 02:06:39 -0500
Date: Tue, 13 Dec 2011 15:57:10 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/3] sched: some fixes for vruntime calculation related to
 cgroup movement
Message-Id: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches fix problems I could see in 3.2-rc2 when testing frequent cgroup movement
under very high load. Without these patches, some processes were not scheduled
(although they were queued into rq)for a very long time(minutes or hours!),
because vruntime of these processes were far bigger than min_vruntime.

Daisuke Nishimura (3):
  sched: fix cgroup movement of newly created process
  sched: fix cgroup movement of forking process
  sched: fix cgroup movement of waking process

 kernel/sched_fair.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)


Thanks,
Daisuke Nishimura.
