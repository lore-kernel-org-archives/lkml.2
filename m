Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2JZKQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:16:37 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1971 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab2JZKQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:16:35 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <508A62DC.50805@broadcom.com>
Date: Fri, 26 Oct 2012 12:15:56 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>
cc: "Tejun Heo" <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: lockdep info message
X-WSS-ID: 7C94BDFE3OW10641703-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and/or Ingo,

I am working on a driver (brcmfmac) and when unloading it or unplugging 
the device I get this info message (see below) upon calling 
cancel_work_sync(). Just wondering if there is something I need to do in 
the driver or should it be done in workqueue code.

Regards,
Arend

[  268.167897] INFO: trying to register non-static key.
[  268.173279] the code is fine but needs lockdep annotation.
[  268.179188] turning off the locking correctness validator.
[  268.185093] Pid: 31, comm: khubd Tainted: G           O 
3.7.0-rc2-testing-lockdep #1
[  268.193254] Call Trace:
[  268.196150]  [<c10929c6>] __lock_acquire+0xb36/0x1780
[  268.201641]  [<c10229fb>] ? lapic_next_event+0x1b/0x20
[  268.207216]  [<c108c0e2>] ? clockevents_program_event+0xb2/0x170
[  268.213654]  [<c108d4e9>] ? tick_program_event+0x29/0x30
[  268.219404]  [<c105f17d>] ? hrtimer_interrupt+0x17d/0x2b0
[  268.225239]  [<c133b170>] ? vt_console_print+0x280/0x350
[  268.231000]  [<c1093b14>] lock_acquire+0x84/0x120
[  268.236152]  [<c1053200>] ? delayed_work_timer_fn+0x30/0x30
[  268.242172]  [<c10943b4>] ? trace_hardirqs_on_caller+0xf4/0x180
[  268.248541]  [<c1053248>] flush_work+0x48/0x250
[  268.253532]  [<c1053200>] ? delayed_work_timer_fn+0x30/0x30
[  268.259562]  [<c109007b>] ? perf_trace_lock+0xb/0x120
[  268.265075]  [<c103af9a>] ? vprintk_emit+0x19a/0x500
[  268.270503]  [<c1054eea>] ? __cancel_work_timer+0x5a/0xb0
[  268.276365]  [<c10943b4>] ? trace_hardirqs_on_caller+0xf4/0x180
[  268.282751]  [<c1054efa>] __cancel_work_timer+0x6a/0xb0
[  268.288426]  [<c1054f6f>] cancel_work_sync+0xf/0x20
[  268.293743]  [<f843d71b>] brcmf_detach+0x7b/0xe0 [brcmfmac]

