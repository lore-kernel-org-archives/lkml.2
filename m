Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2J3G70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 02:59:26 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57828 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab2J3G7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 02:59:25 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-b1-508f7acac71e
From: Namhyung Kim <namhyung@kernel.org>
To: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist periods
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
	<1351537727.4047.21.camel@twins> <508EF6C1.4000302@fb.com>
Date: Tue, 30 Oct 2012 15:59:22 +0900
In-Reply-To: <508EF6C1.4000302@fb.com> (Arun Sharma's message of "Mon, 29 Oct
	2012 14:36:01 -0700")
Message-ID: <87ehkg78dx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun and Peter,

On Mon, 29 Oct 2012 14:36:01 -0700, Arun Sharma wrote:
> On 10/29/12 12:08 PM, Peter Zijlstra wrote:
>
>> Right, so I tried this and I would expect the callchains to be inverted
>> too, so that when I expand say 'c' I would see that 'c' calls 'b' for
>> 100% which calls 'a' for 100%.
>>
>> Instead I get the regular callchains, expanding 'c' gives me main calls
>> it for 100%.
>>
>> Adding -G (invert callchains) doesn't make it better, in that case, when
>> I expand 'c' we start at '__libc_start_main' instead of 'c'.
>>
>> Is there anything I'm missing?
>>
>
> Sounds like a reasonable expectation.
>
> I tested mainly:
>
> perf report --cumulate  -g graph,100,callee
>
> to find the functions with a large amount of CPU time underneath. Then
> examined the callgraph without --cumulate. But yeah - it'd be nice to
> be able to do both in a single invocation.

Yes, the callchain part needs to be improved.  Peter's idea indeed looks
good to me too.

But before doing that, I'd like to get an agreement on how to
design/implement this feature.

Sorry to Frederic (and Stephane), I'm bothering you multiple times with
this but I didn't get what you want exactly.  IIUC you don't want to
have --cumulate option but to share branch sampling code to implement
it, right?

But the branch sampling output looks not fit to --cumulate usage IMHO.
Could you give me an advice?

>
> Also, when callgraphs are displayed, the percentages are off (>
> 100%). Namhyung probably needs to use he->stat_acc->period in a few
> places as the denominator instead of he->period.

I will look into it later.

Thanks,
Namhyung
