Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0KZJ1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:27:55 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33206 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0KZJ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:27:53 -0500
X-AuditID: b753bd60-a4ba2ba000003e7d-df-4cef7d9573aa
Message-ID: <4CEF7D92.1080207@hitachi.com>
Date: Fri, 26 Nov 2010 18:27:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -tip v4 3/3] kprobes: Support delayed unoptimization
References: <20101119100925.16882.34772.stgit@ltc236.sdl.hitachi.co.jp> <20101119100948.16882.24259.stgit@ltc236.sdl.hitachi.co.jp> <20101126072621.GB19589@elte.hu>
In-Reply-To: <20101126072621.GB19589@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/11/26 16:26), Ingo Molnar wrote:
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Unoptimization occurs when a probe is unregistered or disabled, and
>> is heavy because it recovers instructions by using stop_machine().
>> This patch delays unoptimization operations and unoptimize several
>> probes at once by using text_poke_smp_batch().
>> This can avoid unexpected system slowdown coming from stop_machine().
>>
>> Changes in v2:
>> - Use dynamic allocated buffers and params.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>
>>  arch/x86/include/asm/kprobes.h |    4 
>>  arch/x86/kernel/kprobes.c      |   45 ++++
>>  include/linux/kprobes.h        |    2 
>>  kernel/kprobes.c               |  434 +++++++++++++++++++++++++++-------------
>>  4 files changed, 344 insertions(+), 141 deletions(-)
> 
> Hm, this is a scary big patch with non-trivial effects - it should be broken up as 
> much as possible, into successive, bisectable steps. The end result looks mostly 
> fine - it's just this one huge step of a patch that is dangerous.

Agreed, then I'll break it down to several patches.
Thank you for your comment! :)

> 
> Thanks,
> 
> 	Ingo


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
