Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2FSBnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:43:45 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61825 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab2FSBno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:43:44 -0400
X-AuditID: 9c93016f-b7c35ae00000135b-3d-4fdfd945beea
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, weisbec@gmail.com, namhyung.kim@lge.com,
        mingo@kernel.org, peterz@infradead.org
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd plugins
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
	<87lijlhv9v.fsf@sejong.aot.lge.com> <4FDF3D5C.1030209@gmail.com>
	<87d34wi0y3.fsf@sejong.aot.lge.com>
	<1340067793.25903.158.camel@gandalf.stny.rr.com>
	<878vfkhzr8.fsf@sejong.aot.lge.com>
	<1340069162.25903.176.camel@gandalf.stny.rr.com>
Date: Tue, 19 Jun 2012 10:40:09 +0900
In-Reply-To: <1340069162.25903.176.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Mon, 18 Jun 2012 21:26:02 -0400")
Message-ID: <874nq8hyfa.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 21:26:02 -0400, Steven Rostedt wrote:
> On Tue, 2012-06-19 at 10:11 +0900, Namhyung Kim wrote:
>
>> > trace-cmd report -N
>> > [...]
>> >              kvm-6172  [000] 14669573.114126: kvm_entry:            vcpu 0
>> >              kvm-6172  [000] 14669573.114127: kvm_exit:             [FAILED TO PARSE] exit_reason=30 guest_rip=0xffff357a isa=1 info1=217841672 info2=0
>> >              kvm-6172  [000] 14669573.114130: kvm_emulate_insn:     [FAILED TO PARSE] rip=4294915450 csbase=0 len=1 insn=ì[ÃWVS<89>Ã<89>Öš^Gu^Q^O^E flags=5 failed=0
>> >              kvm-6172  [000] 14669573.114130: kvm_pio:              pio_read at 0xcfc size 1 count 1
>> >              kvm-6172  [000] 14669573.114131: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
>> >              kvm-6172  [000] 14669573.114134: kvm_entry:            vcpu 0
>> >
>> 
>> What I want to do is make it not to fail with default print_fmt (ie. w/o
>> plugin support). IOW using a plugin to improve things like above is
>> good, but not using it shouldn't break/fail anything. So I think fixing
>> the TP_printk is needed.
>
> I'm not sure its broken anymore per-say. As I just ran this without
> plugins (with the -N switch) and it doesn't break. It sends out some
> nasty warnings, but continues on its happy way with a warning that it
> '[FAILED TO PARSE]'. And some warnings in the beginning.
>
> But it doesn't totally fail. We could probably clean it up a bit too.
> What it does above is simply print out the raw data and lists the
> fields.
>
> The problem with modifying the TP_printk() is that this is also used by
> raw tracing (the /debug/tracing/trace file). Without using tools. The
> TP_printk() is really for that. The plugins is the way for tools to
> handle it.
>

Ok. Then how about using __print_hex() for __print_insn? AFAICS
ftrace_print_hex_seq() looks almost same as __print_insn() and as it's a
generic function we can add its handler in libtraceevnt.

Thanks,
Namhyung
