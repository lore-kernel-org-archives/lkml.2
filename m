Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487Ab2J2VjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:39:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59643 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751822Ab2J2Vi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:38:57 -0400
Message-ID: <508EF6C1.4000302@fb.com>
Date: Mon, 29 Oct 2012 14:36:01 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist
 periods
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org> <1351537727.4047.21.camel@twins>
In-Reply-To: <1351537727.4047.21.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.254]
X-Proofpoint-Spam-Reason: safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-29_04:2012-10-29,2012-10-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/12 12:08 PM, Peter Zijlstra wrote:

> Right, so I tried this and I would expect the callchains to be inverted
> too, so that when I expand say 'c' I would see that 'c' calls 'b' for
> 100% which calls 'a' for 100%.
>
> Instead I get the regular callchains, expanding 'c' gives me main calls
> it for 100%.
>
> Adding -G (invert callchains) doesn't make it better, in that case, when
> I expand 'c' we start at '__libc_start_main' instead of 'c'.
>
> Is there anything I'm missing?
>

Sounds like a reasonable expectation.

I tested mainly:

perf report --cumulate  -g graph,100,callee

to find the functions with a large amount of CPU time underneath. Then 
examined the callgraph without --cumulate. But yeah - it'd be nice to be 
able to do both in a single invocation.

Also, when callgraphs are displayed, the percentages are off (> 100%). 
Namhyung probably needs to use he->stat_acc->period in a few places as 
the denominator instead of he->period.

  -Arun
