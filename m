Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0DBPAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:00:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55161 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab0DBO76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:59:58 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: 2.6.34-rc3: Badness at kernel/lockdep.c:2706
References: <4BB588B5.1060309@in.ibm.com> <1270218533.5109.525.camel@twins>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 02 Apr 2010 07:59:48 -0700
In-Reply-To: <1270218533.5109.525.camel@twins> (Peter Zijlstra's message of "Fri\, 02 Apr 2010 16\:28\:53 +0200")
Message-ID: <m14ojtrjbv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: peterz@infradead.org, w.sang@pengutronix.de, linuxppc-dev@ozlabs.org, mingo@redhat.com, linux-kernel@vger.kernel.org, sachinp@in.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Could you try the fix Wolfram Sang sent to linux-kernel yesterday?

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, 2010-04-02 at 11:33 +0530, Sachin Sant wrote:
>> With 2.6.34-rc3 boot on a Power5 box :
>> 
>> loop: module loaded
>> BUG: key 6b6b6b6b6b6b6b6b not in .data!
>> ------------[ cut here ]------------
>> Badness at kernel/lockdep.c:2706
>> NIP: c00000000010a0a8 LR: c00000000010a08c CTR: c0000000000704a4
>> REGS: c0000001096d76f0 TRAP: 0700   Not tainted  (2.6.34-rc3)
>> MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28000082  XER: 00000009
>> TASK = c0000001fa6f8000[1] 'swapper' THREAD: c0000001096d4000 CPU: 12
>> GPR00: 0000000000000000 c0000001096d7970 c000000001322e38 0000000000000001
>> GPR04: 0000000000000001 c0000000000c1ea8 0000000000000000 0000000000000002
>> GPR08: 0000000000000000 c000000001cc5a00 0000000000002422 c00000000137d768
>> GPR12: 0000000000000002 c00000000f66e400 0000000000d47940 0000000001c00000
>> GPR16: ffffffffffffffff 0000000002673148 00000000018ff984 0000000000000060
>> GPR20: 0000000000000000 ffffffffffffffff 000000000253a291 00000000018ff990
>> GPR24: 00000000018ff988 c000000001229ef0 0000000000000000 c00000010793a730
>> GPR28: 6b6b6b6b6b6b6b6b c00000010793afd8 c000000001299de0 c0000001096d7970
>> NIP [c00000000010a0a8] .lockdep_init_map+0x12c/0x538
>> LR [c00000000010a08c] .lockdep_init_map+0x110/0x538
>> Call Trace:
>> [c0000001096d7970] [c00000000010a074] .lockdep_init_map+0xf8/0x538 (unreliable)
>> [c0000001096d7a30] [c000000000274eac] .sysfs_add_file_mode+0x90/0x124
>> [c0000001096d7af0] [c000000000274f7c] .sysfs_add_file+0x3c/0x50
>> [c0000001096d7b90] [c0000000002750d8] .sysfs_create_file+0x5c/0x74
>> [c0000001096d7c30] [c0000000004b36a0] .device_create_file+0x40/0x5c
>> [c0000001096d7cd0] [c0000000004db384] .wf_register_control+0x108/0x178
>> [c0000001096d7d80] [c000000000a5f7cc] .wf_cpufreq_clamp_init+0x11c/0x16c
>> [c0000001096d7e20] [c00000000000a104] .do_one_initcall+0xb0/0x208
>> [c0000001096d7ed0] [c000000000a12568] .kernel_init+0x230/0x2f0
>> [c0000001096d7f90] [c000000000033b20] .kernel_thread+0x54/0x70
>> Instruction dump:
>> e93e8190 80090000 2f800000 409e03f8 48280539 60000000 2fa30000 419e03e8
>> e93e8198 80090000 2f800000 409e03d8 <0fe00000> 480003d0 e93e8140 fb9d0000
>> Uniform Multi-Platform E-IDE driver
>
> 0x6b is POISON_FREE, so it seems to me sysfs made a boo-boo.

Interesting combination of debugging options there.  First time I have
seen BUG: xyz not in .data with a 0x6b address...

Eric

