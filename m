Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab0LMRh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:37:27 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54558 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab0LMRh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:37:26 -0500
Message-ID: <4D0659D6.7000803@dcl.info.waseda.ac.jp>
Date: Tue, 14 Dec 2010 02:37:26 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b8pre) Gecko/20101116 Thunderbird/3.3a1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        yakui.zhao@intel.com, fweisbec@gmail.com, ling.ma@intel.com,
        rostedt@goodmis.org, miaox@cn.fujitsu.com, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: perf monitoring triggers Was: Re: [tip:perf/core] perf bench:
 Print both of prefaulted and no prefaulted results by default
References: <1290668693-27068-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <tip-49ce8fc651794878189fd5f273228832cdfb5be9@git.kernel.org> <4D03B1AD.7000606@dcl.info.waseda.ac.jp> <20101212134657.GA19166@ghostprotocols.net> <1292238873.6803.183.camel@twins> <20101213123810.GA5407@ghostprotocols.net> <1292244059.6803.203.camel@twins> <20101213131218.GC5407@ghostprotocols.net>
In-Reply-To: <20101213131218.GC5407@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年12月13日 22:12, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 13, 2010 at 01:40:59PM +0100, Peter Zijlstra escreveu:
>> On Mon, 2010-12-13 at 10:38 -0200, Arnaldo Carvalho de Melo wrote:
>>> Em Mon, Dec 13, 2010 at 12:14:33PM +0100, Peter Zijlstra escreveu:
>>>> Sounds to me like you want something like a library with self-monitoring
>>>> stuff.
>
>>> Yeah, that could be a way, an LD_PRELOAD thingy that would intercept
>>> library calls, setup counters, start a monitoring thread, etc.
>
>>> To make it easier we could move the counter setup we have in record/top
>>> to a library, etc.
>>
>> Nah, I was more thinking of something along the lines of libPAPI and
>> libpfmon. A library that contains the needed building blocks for apps to
>> profile themselves.
>
> Ok, you mean for the case where you can modify the app, I was thinking
> about when you can't.
>
> In both cases its good to move the counter creation, etc routines from
> record/top to a lib, that then could be used in the way you mention, and
> in the way I mention too. Two different usecases :-)

Thanks for your comments, Arnaldo, Peter.

I implement basic feature of my proposal,
and found that communicating perf stat and benchmarking programs
via socket is really dirty. As you said, unified form,
interception for unmodified binary and library for modifiable binary,
will be ideal for fine grain monitoring.

But I believe that measuring performance of some sort of programs
like in kernel routines requires more fine grain perf stating,
so I'll seek the unified way.

Anyway, I'll send my proof of concept patch later.

Thanks,
         Hitoshi

