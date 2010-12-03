Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0LCQqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 11:46:38 -0500
Received: from smtp-out.google.com ([74.125.121.35]:54398 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0LCQqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 11:46:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wMToS1YQ52pvPkY29TAaClL8LQEZ/t7nUJDekolsfreIuLZ+8lkNEguKwcFj3dePiz
         GPNhbDJBxzev0TET05Bg==
MIME-Version: 1.0
In-Reply-To: <20101201185452.GB26071@ghostprotocols.net>
References: <4cf68aa7.0fedd80a.5294.1203@mx.google.com>
	<20101201181001.GA26071@ghostprotocols.net>
	<20101201185452.GB26071@ghostprotocols.net>
Date: Fri, 3 Dec 2010 17:46:33 +0100
Message-ID: <AANLkTik-xNNV2DNhTCREJpFh5RgazxOB9yEoqZYu-B8J@mail.gmail.com>
Subject: Re: [PATCH] perf: add csv-style output to perf stat (v2)
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

sorry for the delay. The upstream version works for me.
Thanks.


On Wed, Dec 1, 2010 at 7:54 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Wed, Dec 01, 2010 at 04:10:01PM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Wed, Dec 01, 2010 at 06:49:05PM +0200, Stephane Eranian escreveu:
>> > This patch adds an option (-x/--field-separator) to print counts using
>> > a CSV-style output. The user can pass a custom separator. This makes it
>> > very easy to import counts directly into your favorite spreadsheet without
>> > having to write scripts.
>>
>> [root@mica ~]# perf stat -x,  -a -A -- sleep 1
>> -B option not supported with -x
>>
>>  usage: perf stat [<options>] [<command>]
>>
>>     -e, --event <event>   event selector. use 'perf list' to list
>>
>> Guess we'll have to disable big_num automatically when -x is specified,
>> but at the same time notice if the user _explicitely_ asked for -B.
>>
>> I'll fix this now.
>
> Should be OK now, patch attached. Please check if it works as expected
> and then I'll push it to Ingo, thanks.
>
> [root@mica ~]# perf stat -x, -a -A -- sleep 1 2>&1 | head -5
> CPU0,998.225789,task-clock-msecs
> CPU1,998.385393,task-clock-msecs
> CPU2,998.370913,task-clock-msecs
> CPU3,998.356865,task-clock-msecs
> CPU0,2272,context-switches
> [root@mica ~]# perf stat -B -x, -a -A -- sleep 1 2>&1 | head -5
> -B option not supported with -x
>
>  usage: perf stat [<options>] [<command>]
>
>    -e, --event <event>   event selector. use 'perf list' to list available events
> [root@mica ~]# perf stat -B -a -- sleep 1 2>&1 | head -10
>
>  Performance counter stats for 'sleep 1':
>
>       3992.488962 task-clock-msecs         #      3.988 CPUs
>             9,082 context-switches         #      0.002 M/sec
>                15 CPU-migrations           #      0.000 M/sec
>               160 page-faults              #      0.000 M/sec
>        84,802,643 cycles                   #     21.241 M/sec  (scaled from 70.03%)
>        45,056,634 instructions             #      0.531 IPC    (scaled from 80.02%)
>         8,672,889 branches                 #      2.172 M/sec  (scaled from 80.01%)
> [root@mica ~]# perf stat -B -A -a -- sleep 1 2>&1 | head -10
>
>  Performance counter stats for 'sleep 1':
>
> CPU0            998.135082 task-clock-msecs         #      0.997 CPUs
> CPU1            998.137405 task-clock-msecs         #      0.997 CPUs
> CPU2            998.144046 task-clock-msecs         #      0.997 CPUs
> CPU3            998.146202 task-clock-msecs         #      0.997 CPUs
> CPU0                 2,280 context-switches         #      0.002 M/sec
> CPU1                 2,282 context-switches         #      0.002 M/sec
> CPU2                 2,244 context-switches         #      0.002 M/sec
> [root@mica ~]# perf stat --no-big-num -A -a -- sleep 1 2>&1 | head -10
>
>  Performance counter stats for 'sleep 1':
>
> CPU0            998.125848 task-clock-msecs         #      0.997 CPUs
> CPU1            998.244633 task-clock-msecs         #      0.997 CPUs
> CPU2            998.337969 task-clock-msecs         #      0.997 CPUs
> CPU3            998.313756 task-clock-msecs         #      0.997 CPUs
> CPU0                  2268 context-switches         #      0.002 M/sec
> CPU1                  2218 context-switches         #      0.002 M/sec
> CPU2                  2218 context-switches         #      0.002 M/sec
> [root@mica ~]#
>
