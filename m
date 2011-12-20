Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1LTNSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 08:18:16 -0500
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:59750 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1LTNSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 08:18:10 -0500
Message-Id: <4EF0991C020000A1000087CB@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 20 Dec 2011 14:18:04 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: print_cfs_rq() in kernel/sched_debug.c (2.6.32.49-0.3, SLES
 10 SP1
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm debuggin  some problem with disk I/O hanging. So I dumped the blocked =
tasks (SysRq : Show Blocked State). I don't understand all the internals =
of the output, but I wondered why the vruntime max is smaller than the =
vruntime min in cfs_rq:

Dec 19 14:24:57 h01 kernel: [2241368.267723] cfs_rq[0]:/
Dec 19 14:24:57 h01 kernel: [2241368.267727]   .exec_clock                 =
   : 6494556.016152
Dec 19 14:24:57 h01 kernel: [2241368.267732]   .MIN_vruntime               =
   : 0.000001
Dec 19 14:24:57 h01 kernel: [2241368.267736]   .min_vruntime               =
   : 36574276.029743
Dec 19 14:24:57 h01 kernel: [2241368.267740]   .max_vruntime               =
   : 0.000001
Dec 19 14:24:57 h01 kernel: [2241368.267743]   .spread                     =
   : 0.000000
Dec 19 14:24:57 h01 kernel: [2241368.267747]   .spread0                    =
   : 0.000000
Dec 19 14:24:57 h01 kernel: [2241368.267751]   .nr_running                 =
   : 0
Dec 19 14:24:57 h01 kernel: [2241368.267754]   .load                       =
   : 0
Dec 19 14:24:57 h01 kernel: [2241368.267758]   .nr_spread_over             =
   : 939
Dec 19 14:24:57 h01 kernel: [2241368.267762]   .shares                     =
   : 0

The code for the max looks like this:

        if (last)
                max_vruntime =3D last->vruntime;

First I suspected the error in the printf section.

Ist there anything wrong, or is it my misunderstanding?

More samples:
Dec 19 14:24:57 h01 kernel: [2241368.267937]   .MIN_vruntime               =
   : 0.000001
Dec 19 14:24:57 h01 kernel: [2241368.267941]   .min_vruntime               =
   : 48353350.463240
Dec 19 14:24:57 h01 kernel: [2241368.267945]   .max_vruntime               =
   : 0.000001

Dec 19 14:24:57 h01 kernel: [2241368.268138]   .MIN_vruntime               =
   : 0.000001
Dec 19 14:24:57 h01 kernel: [2241368.268142]   .min_vruntime               =
   : 34269914.013038
Dec 19 14:24:57 h01 kernel: [2241368.268146]   .max_vruntime               =
   : 0.000001

Regards,
Ulrich
P.S.: Please CC: any replies to me as I'm not subscribed to the kernel =
list


