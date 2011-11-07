Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab1KGM4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:56:12 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:14431 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab1KGM4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:56:11 -0500
Message-ID: <4EB7D566.40900@parallels.com>
Date: Mon, 07 Nov 2011 16:56:06 +0400
From: Andrew Vagin <avagin@parallels.com>
Reply-To: avagin@parallels.com, avagin@gmail.com
Organization: parallels
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, devel@openvz.org
Subject: Re: [PATCH 3/4] perf: teach perf inject to merge sched_stat_* and
 sched_switch events
References: <1320274784-2463901-1-git-send-email-avagin@openvz.org> <1320274784-2463901-4-git-send-email-avagin@openvz.org> <4EB32D1B.8060305@fb.com>
In-Reply-To: <4EB32D1B.8060305@fb.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

On 11/04/2011 04:08 AM, Arun Sharma wrote:
> On 11/2/11 3:59 PM, Andrew Vagin wrote:
>
>> + event_sw = (union perf_event *)&ent->header;
>
> This causes problems with -Wstrict-aliasing=3.
I didn't see any warning, but I reworked this part a bit.
>
> I noticed that the suggested cmdline is:
>
> perf script record sched-stat -- -e sched:sched_stat_sleep
>
> I'd much prefer something along the lines of:
>
> perf script record sched-stat -e <events> -- sleep 1
>
> Also, the perf inject command is a bit unforgiving when the user makes
> some mistakes (eg: didn't specify -e sched:sched_stat_sleep). The
> failure mode is hard to understand (perf report -i perf.data.d fails
> with "no samples").

I see the problem. It's not in "perf inject". Look at new version I 
improved "perf script sched_stat". Now it may be executed for specific 
command and it reports an error if you forgot to set a sched_stat_* event.

> Could not find sched_switch for pid 16179
>
> I think this is the same issue you referenced in "Known issues".
Actually It isn't. Now I print this message as debug information.
>
> Although I'm able to get some profiling info out of perf.data.d, the
> process I really wanted to trace got zero samples.
It's strange. Can you check new versions and describe the experiment if 
it will be reproduces.
>
> -Arun
>

