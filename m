Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1ASBNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:13:04 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44762 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1ASBND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:13:03 -0500
X-AuditID: b753bd60-a0492ba000000ca4-73-4d363a9a6add
Message-ID: <4D363A98.8020906@hitachi.com>
Date: Wed, 19 Jan 2011 10:12:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [PATCH -perf/perf/core  5/6] perf probe: Add variable filter
 support
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp> <20110113124624.22426.72527.stgit@ltc236.sdl.hitachi.co.jp> <m3wrm87ba7.fsf@gmail.com> <4D2FB7FD.3020004@hitachi.com> <20110117120721.GB3902@ghostprotocols.net>
In-Reply-To: <20110117120721.GB3902@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/17 21:07), Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 14, 2011 at 11:42:05AM +0900, Masami Hiramatsu escreveu:
>> (2011/01/14 6:18), Franck Bui-Huu wrote:
>>> I'm wondering if the different syntax below could be simpler:
>>>
>>>    $ perf probe add <probe>
>>>    $ perf probe del <probe>
>>>    $ perf probe show       
>>>    $ perf probe list <line>
>>>            ...       --vars[=<pattern>] [--externs] <probe>
>>>            ...       --funcs[=<pattern>]
>  
>> Hm, well, if no one complains about changing the syntax of perf probe,
>> it may make things simple (maybe we'll also have to drop "perf probe
>> <PROBE>" syntax). Nowadays we already have perf-kvm, perf-sched, etc.
>> which use sub-sub commands.
>  
>> IMHO, for avoiding confusion old options and "perf-list", below
>> sub-sub commands are more suitable.
>  
>>    $ perf probe add <probe>
>>    $ perf probe del <probe>
>>    $ perf probe list
>>    $ perf probe lines <line>
>>    $ perf probe vars [--filter=<pattern>|-F <pattern>] [--extern] <probe>
>>    $ perf probe funcs [--filter=<pattern>|-F <pattern>]
> 
> Right, and when packaging, we can do just like Ingo and Thomas are doing
> with 'perf trace', create a hardlink and if argv[0] is 'probe', that is
> an alias to 'perf probe', so we would do it just like:
> 
> $ probe add <probe>
> $ probe del <probe>
> $ probe list
> $ probe lines <line>
> $ probe vars [--filter=<pattern>|-F <pattern>] [--extern] <probe>
> $ probe funcs [--filter=<pattern>|-F <pattern>]

Looks good! :)

BTW, it seems that 'make clean' doesn't cleanup that
'trace' hardlink...

> 
> [root@felicio ~]# probe
> bash: probe: command not found...
> 
> Also google told me that there was an /sbin/probe utility, but that was
> a long time ago, in the kernel-pcmcia-cs package, nowadays we have
> pcmciautils and it doesn't have this command, so I think it is up for
> grabs :-)
> 
> So I think that the 'probe funcs' makes sense, will apply that patch in
> perf/core.

Thanks!


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
