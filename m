Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111Ab0KDQT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:19:59 -0400
Received: from smtp-out-083.synserver.de ([212.40.180.83]:1225 "EHLO
	smtp-out-081.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750825Ab0KDQT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:19:57 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 10519
Date: Thu, 4 Nov 2010 17:19:43 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20101104161943.GA6520@arch.trippelsdorf.de>
References: <20101104155826.GC13818@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104155826.GC13818@swordfish.minsk.epam.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 05:58:26PM +0200, Sergey Senozhatsky wrote:
> Hello,
> Got the following traces:
> 
> [42001.449295] INFO: task openbox:17761 blocked for more than 120 seconds.
> [42001.449303] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [42001.449311] openbox       D 0000000000000003     0 17761   3723 0x00000000
> [42001.449321]  ffff88004ce8dc38 0000000000000046 0000000000000000 ffff88004ce8c000
> [42001.449333]  ffff88004ce8dfd8 0000000000012040 ffff880133010000 ffff88004ce8dfd8
> [42001.449343]  0000000000012040 0000000000012040 ffff88004ce8dfd8 0000000000012040
> [42001.449354] Call Trace:
> [42001.449369]  [<ffffffff814212ff>] schedule_timeout+0x38/0x220
> [42001.449381]  [<ffffffff81066f21>] ? mark_held_locks+0x50/0x72
> [42001.449389]  [<ffffffff81423dae>] ? _raw_spin_unlock_irq+0x2b/0x59
> [42001.449398]  [<ffffffff81036070>] ? get_parent_ip+0x11/0x41
> [42001.449406]  [<ffffffff81036132>] ? sub_preempt_count+0x92/0xa5
> [42001.449413]  [<ffffffff8142057e>] wait_for_common+0xca/0x144
> [42001.449421]  [<ffffffff81038b13>] ? default_wake_function+0x0/0xf
> [42001.449429]  [<ffffffff81423e4b>] ? _raw_spin_unlock_irqrestore+0x6f/0x74
> [42001.449436]  [<ffffffff81420692>] wait_for_completion+0x18/0x1a
> [42001.449445]  [<ffffffff81084808>] stop_one_cpu+0x8c/0xba

These traces look related to:
http://article.gmane.org/gmane.linux.kernel/1055100

Does reverting 34f971f6f7988be4d014eec3e3526bee6d007ffa help in your
case?

-- 
Markus
