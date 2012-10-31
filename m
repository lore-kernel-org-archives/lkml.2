Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab2JaHMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:12:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47620 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2JaHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:12:30 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-3d-5090cf5b605b
From: Namhyung Kim <namhyung@kernel.org>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Arnaldo de Melo <acme@infradead.org>, mingo@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        akshay kumar <iit.akshay@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf report: different reports when run on terminal as opposed to script
References: <CAPhKKr8HAbAw2jdvva6oJYj747ZS0dTakz2=qJXN+NsTiu=dCg@mail.gmail.com>
	<CAPhKKr8KNi0kU4CcbPofZT7sghumeUTRyiuywOWrd24DiF4gFQ@mail.gmail.com>
	<871ugg76dn.fsf@sejong.aot.lge.com>
	<CAPhKKr_S0-r-Bx9KWeFyN1KwTcLf-Rt8f55_c0bohaJh0JQ0cg@mail.gmail.com>
Date: Wed, 31 Oct 2012 16:12:27 +0900
In-Reply-To: <CAPhKKr_S0-r-Bx9KWeFyN1KwTcLf-Rt8f55_c0bohaJh0JQ0cg@mail.gmail.com>
	(Dhaval Giani's message of "Tue, 30 Oct 2012 08:05:45 -0400")
Message-ID: <87625r5d44.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 08:05:45 -0400, Dhaval Giani wrote:
> On Tue, Oct 30, 2012 at 3:42 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> Hi Dhaval,
>>
>> On Mon, 29 Oct 2012 12:45:53 -0400, Dhaval Giani wrote:
>>> On Mon, Oct 29, 2012 at 12:01 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> As part of a class assignment I have to collect some performance
>>>> statistics. In order to do so I run
>>>>
>>>> perf record -g <the program I have to profile>
>>>>
>>>> And in another window, I start 200 threads of the load generator
>>>> (which is not recorded by perf)
>>>>
>>>> This generates me statistics that I expect to see, and I am happy. As
>>>> this is academia and a class assignment, I need to collect information
>>>> and analyze it across different setups. Which of course meant I script
>>>> this whole thing, which basically is
>>>>
>>>> for i in all possibilities
>>>> do
>>>> perf record -g <the program I have to profile> &
>>>> WAITPID=$!
>>>> for j in NR_THREADS
>>>> do
>>>> <start load generator> &
>>>> KILLPID=$!
>>>> done
>>>> wait $PID
>>
>> You meant $WAITPID, right?
>>
>
> yes. grrr. I changed the name here to WAITPID for it to be clear and
> that was a fail. (I blame the cold)
>
>>
>>>> kill $KILLPID
>>
>> Doesn't it kill the last load generator only?
>>
>>
>
> Well, this was a bug in me typing the pseudo code. the actual script
> does "$KILLPID $!"

Okay, so I suspect that it might be affected by the autogroup scheduling
feature since you said running load generators in another window - I
guess it's a terminal.  How about running them with setsid?

Thanks,
Namhyung

