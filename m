Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925Ab2DLD2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:28:01 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36134 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab2DLD17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:27:59 -0400
X-AuditID: b753bd60-95b8eba000007b1b-2b-4f864bbc708b
X-AuditID: b753bd60-95b8eba000007b1b-2b-4f864bbc708b
Message-ID: <4F864BB3.3090405@hitachi.com>
Date: Thu, 12 Apr 2012 12:27:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: Re: [PATCH] perf/probe: Provide perf interface for uprobes
References: <20120411135742.29198.45061.sendpatchset@srdronam.in.ibm.com> <20120411144918.GD16257@infradead.org> <20120411170343.GB29831@linux.vnet.ibm.com> <20120411181727.GK16257@infradead.org>
In-Reply-To: <20120411181727.GK16257@infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/12 3:17), Arnaldo Carvalho de Melo wrote:
> Em Wed, Apr 11, 2012 at 10:42:25PM +0530, Srikar Dronamraju escreveu:
>> * Arnaldo Carvalho de Melo <acme@infradead.org> [2012-04-11 11:49:18]:
>>> Em Wed, Apr 11, 2012 at 07:27:42PM +0530, Srikar Dronamraju escreveu:
>>>> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>>>>
>>>> - Enhances perf to probe user space executables and libraries.
>>>> - Enhances -F/--funcs option of "perf probe" to list possible probe points in
>>>>   an executable file or library.
>>>> - Documents userspace probing support in perf.
>>>>
>>>> [ Probing a function in the executable using function name  ]
>>>> perf probe -x /bin/zsh zfree
>>>
>>> Can we avoid the need for -x? I.e. we could figure out it is userspace
>>> and act accordingly.
>>
>> To list the functions in the module ipv6, we use "perf probe -F -m ipv6"
>> So I used the same logic to use -x for specifying executables.
>>
>> This is in agreement with probepoint addition where without any
>> additional options would mean kernel probepoint; m option would mean
>> module and x option would mean user space executable. 
>>
>> However if you still think we should change, do let me know.
> 
> Yeah, if one needs to disambiguate, sure, use these keywords, but for
> things like:
> 
> $ perf probe /lib/libc.so.6 malloc
> 
> I think it is easy to figure out it is userspace. I.e. some regex would
> figure it out.

That's interessting to me too. Maybe it is also useful syntax for
module specifying too.

e.g.
  perf probe -m kvm kvm_timer_fn

can be

  perf probe kvm.ko kvm_timer_fn

(.ko is required) or if unloaded

  perf probe /lib/modules/XXX/kernel/virt/kvm.ko kvm_timer_fn

Thanks!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
