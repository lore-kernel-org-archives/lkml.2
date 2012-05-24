Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2EXMNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:13:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47568 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2EXMNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:13:21 -0400
MIME-Version: 1.0
In-Reply-To: <1337852033.9783.80.camel@laptop>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	<1337801535-12865-2-git-send-email-jolsa@redhat.com>
	<1337852033.9783.80.camel@laptop>
Date: Thu, 24 May 2012 14:13:19 +0200
Message-ID: <CABPqkBTshaU6cMnrcbO9aQ5GyO4rbNSSSP6_3DCD0YSZgS7tXA@mail.gmail.com>
Subject: Re: [PATCH 01/16] perf: Unified API to record selective sets of arch registers
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/24 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
>> +enum perf_event_x86_32_regs {
>> +       PERF_X86_32_REG_EAX,
>> +       PERF_X86_32_REG_EBX,
>> +       PERF_X86_32_REG_ECX,
>> +       PERF_X86_32_REG_EDX,
>> +       PERF_X86_32_REG_ESI,
>> +       PERF_X86_32_REG_EDI,
>> +       PERF_X86_32_REG_EBP,
>> +       PERF_X86_32_REG_ESP,
>> +       PERF_X86_32_REG_EIP,
>> +       PERF_X86_32_REG_FLAGS,
>> +       PERF_X86_32_REG_CS,
>> +       PERF_X86_32_REG_DS,
>> +       PERF_X86_32_REG_ES,
>> +       PERF_X86_32_REG_FS,
>> +       PERF_X86_32_REG_GS,
>> +
>> +       /* Non ABI */
>> +       PERF_X86_32_REG_MAX,
>> +};
>
>> +enum perf_event_x86_64_regs {
>> +       PERF_X86_64_REG_RAX,
>> +       PERF_X86_64_REG_RBX,
>> +       PERF_X86_64_REG_RCX,
>> +       PERF_X86_64_REG_RDX,
>> +       PERF_X86_64_REG_RSI,
>> +       PERF_X86_64_REG_RDI,
>> +       PERF_X86_64_REG_R8,
>> +       PERF_X86_64_REG_R9,
>> +       PERF_X86_64_REG_R10,
>> +       PERF_X86_64_REG_R11,
>> +       PERF_X86_64_REG_R12,
>> +       PERF_X86_64_REG_R13,
>> +       PERF_X86_64_REG_R14,
>> +       PERF_X86_64_REG_R15,
>> +       PERF_X86_64_REG_RBP,
>> +       PERF_X86_64_REG_RSP,
>> +       PERF_X86_64_REG_RIP,
>> +       PERF_X86_64_REG_FLAGS,
>> +       PERF_X86_64_REG_CS,
>> +       PERF_X86_64_REG_SS,
>> +
>> +       /* Non ABI */
>> +       PERF_X86_64_REG_MAX,
>> +};
>
> So why bother with two different APIs? Why not have only the x86_64 one
> and maybe add a warning/error/fail whatever when x86_64 regs are
> selected on i386/compat tasks.
>
>
I agree with Peter here especially after our earlier discussion about how
to handle 32-bit ABI threads on a 64-bit ABI kernel. You should simply
fill in the record with zeroes when the register does not exists. You cannot
predict what will be sampled in system-wide mode.

The only sanity check you can do is on 32-bit ABI kernel, reject any 64-bit
ABI only regs but then that would require invoking arch specific code from
perf_copy_attr()....
