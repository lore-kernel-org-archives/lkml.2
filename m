Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab1ANCmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:42:17 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35652 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1ANCmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 21:42:13 -0500
X-AuditID: b753bd60-9e55eba000000f65-85-4d2fb8027156
Message-ID: <4D2FB7FD.3020004@hitachi.com>
Date: Fri, 14 Jan 2011 11:42:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [PATCH -perf/perf/core  5/6] perf probe: Add variable filter
 support
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>	<20110113124624.22426.72527.stgit@ltc236.sdl.hitachi.co.jp> <m3wrm87ba7.fsf@gmail.com>
In-Reply-To: <m3wrm87ba7.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/14 6:18), Franck Bui-Huu wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> 
>> Add filters support for available variable list.
>> Default filter is "!__k???tab_*&!__crc_*" for
>> filtering out automatically generated symbols.
>>
>> The format of filter rule is "[!]GLOBPATTERN", so
>> you can use wild cards. If the filter rule starts with
>> '!', matched variables are filter out.
>>
>> e.g.)
>>  # perf probe -V schedule --externs --filter=cpu*
> 
> I'm wondering if the different syntax below could be simpler:
> 
>    $ perf probe add <probe>
>    $ perf probe del <probe>
>    $ perf probe show       
> 
>    $ perf probe list <line>
>            ...       --vars[=<pattern>] [--externs] <probe>
>            ...       --funcs[=<pattern>]

Hm, well, if no one complains about changing the syntax
of perf probe, it may make things simple (maybe we'll also
have to drop "perf probe <PROBE>" syntax). Nowadays
we already have perf-kvm, perf-sched, etc. which use sub-sub
commands.

IMHO, for avoiding confusion old options and "perf-list", below
sub-sub commands are more suitable.

   $ perf probe add <probe>
   $ perf probe del <probe>
   $ perf probe list
   $ perf probe lines <line>
   $ perf probe vars [--filter=<pattern>|-F <pattern>] [--extern] <probe>
   $ perf probe funcs [--filter=<pattern>|-F <pattern>]

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
