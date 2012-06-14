Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2FNQYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:24:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16549 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab2FNQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:24:10 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=S7kPoNjUNpsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=1buXoMyhbuoRyIMXbZsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339691048.13377.233.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] perf script: format regression due to libtraceevent
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        fweisbec@gmail.com, namhyung.kim@lge.com
Date: Thu, 14 Jun 2012 12:24:08 -0400
In-Reply-To: <1339688920-62816-1-git-send-email-dsahern@gmail.com>
References: <1339688920-62816-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 09:48 -0600, David Ahern wrote:
> Consider the commands:
> perf record -e sched:sched_switch -fo /tmp/perf-3.5.data  -a -- sleep 1
> perf script -i /tmp/perf.data
> 
> In v3.4 the output has the form (lines wrapped)
>             perf 29214 [005] 821043.582596: sched_switch:
> prev_comm=perf prev_pid=29214 prev_prio=120
> prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120
> 
> In 3.5 that same line has become:
>            perf 29214 [005] 821043.582596: sched_switch:
>             <...>-29214 [005]     0.000000000: sched_switch:
>          prev_comm=perf prev_pid=29214 prev_prio=120
> prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120
> 
> Note the duplicates in the output -- pid, cpu, event name. With
> this patch the v3.4 output is restored:
>            perf 29214 [005] 821043.582596: sched_switch:
> prev_comm=perf prev_pid=29214 prev_prio=120
> prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120
> 

This patch breaks trace-cmd (as well as the API). I recommend adding
another function that just does what you want and call that instead.

-- Steve


