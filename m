Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab0DJQsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 12:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0DJQsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 12:48:38 -0400
Message-ID: <4BC0ABCA.1020004@redhat.com>
Date: Sat, 10 Apr 2010 12:48:10 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip v2 7/8] perf probe: Remove die() from probe-finder
 code
References: <20100406220542.13329.45837.stgit@localhost6.localdomain6> <20100406220629.13329.71869.stgit@localhost6.localdomain6> <4BBFB5CE.7070104@redhat.com> <20100410012815.GC16721@ghostprotocols.net> <4BBFFC86.4020201@redhat.com> <20100410142700.GN3908@ghostprotocols.net>
In-Reply-To: <20100410142700.GN3908@ghostprotocols.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Sat, Apr 10, 2010 at 12:20:22AM -0400, Masami Hiramatsu escreveu:
>> Arnaldo Carvalho de Melo wrote:
>>> Em Fri, Apr 09, 2010 at 07:18:38PM -0400, Masami Hiramatsu escreveu:
>>>>>  	tvar->value = xstrdup(regs);
>>>>>  	if (ref) {
>>>>>  		tvar->ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));
>>>
>>> We have to kill those xzcalloc, etc, too they are die() in disguise :-)
>>
>> Hmm, I think that will cost high, because only failing to allocate memory,
>> which theoretically means we can't continue to operate it. In that case,
>> we'd better just use backtrace() and die().
> 
> Consider a situation where we are trying to allocate lots of objects
> allocated for some big operation (adding probes for all functions in all
> threads, whatever), we can just say to the user "hey, you don't have
> memory to do this" but other operations are possible, so calling
> panic(), oops, die() is not the right thing to do.

Hmm, OK, so we'd better remove wrapper.c...

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
