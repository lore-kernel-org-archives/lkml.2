Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2CMPry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:47:54 -0400
Received: from mail2.charite.de ([141.42.206.200]:44324 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab2CMPrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:47:51 -0400
Date: Tue, 13 Mar 2012 16:47:48 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: [3.2.9] INFO: rcu_bh detected stall on CPU 2 (t=0 jiffies)
Message-ID: <20120313154748.GT15693@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found this on my ProLiant DL360 G5 yesterday:

Mar 12 12:58:38 mail kernel: [440746.244002] INFO: rcu_bh detected stall on CPU 2 (t=0 jiffies)
Mar 12 12:58:38 mail kernel: [440746.244002] Pid: 27980, comm: /usr/sbin/amavi Tainted: G        W    3.2.9 #1
Mar 12 12:58:38 mail kernel: [440746.244002] Call Trace:
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1061d26>] ? __rcu_pending+0x10a/0x30e
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c10626ca>] ? rcu_check_callbacks+0xd4/0xde
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1035cf2>] ? update_process_times+0x2a/0x53
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c104e1d2>] ? tick_sched_timer+0x4d/0x8e
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1043b53>] ? __remove_hrtimer+0x25/0x79
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1043d4f>] ? __run_hrtimer.isra.32+0x37/0xbd
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c10445d5>] ? hrtimer_interrupt+0xdb/0x23d
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c101b781>] ? vmalloc_sync_all+0x1/0x1
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1015e4c>] ? smp_apic_timer_interrupt+0x4c/0x81
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1275491>] ? apic_timer_interrupt+0x31/0x38
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c101b781>] ? vmalloc_sync_all+0x1/0x1
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c101b8c2>] ? do_page_fault+0x141/0x38f
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1030d8d>] ? irq_exit+0x34/0x87
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1015e51>] ? smp_apic_timer_interrupt+0x51/0x81
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c101b781>] ? vmalloc_sync_all+0x1/0x1
Mar 12 12:58:38 mail kernel: [440746.244002]  [<c12756b7>] ? error_code+0x67/0x6c

Shoild I worry?

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
