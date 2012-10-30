Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721Ab2J3MFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:05:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50676 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab2J3MFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:05:46 -0400
MIME-Version: 1.0
In-Reply-To: <871ugg76dn.fsf@sejong.aot.lge.com>
References: <CAPhKKr8HAbAw2jdvva6oJYj747ZS0dTakz2=qJXN+NsTiu=dCg@mail.gmail.com>
	<CAPhKKr8KNi0kU4CcbPofZT7sghumeUTRyiuywOWrd24DiF4gFQ@mail.gmail.com>
	<871ugg76dn.fsf@sejong.aot.lge.com>
Date: Tue, 30 Oct 2012 08:05:45 -0400
Message-ID: <CAPhKKr_S0-r-Bx9KWeFyN1KwTcLf-Rt8f55_c0bohaJh0JQ0cg@mail.gmail.com>
Subject: Re: [BUG] perf report: different reports when run on terminal as
 opposed to script
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo de Melo <acme@infradead.org>, mingo@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        akshay kumar <iit.akshay@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 3:42 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Dhaval,
>
> On Mon, 29 Oct 2012 12:45:53 -0400, Dhaval Giani wrote:
>> On Mon, Oct 29, 2012 at 12:01 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
>>> Hi,
>>>
>>> As part of a class assignment I have to collect some performance
>>> statistics. In order to do so I run
>>>
>>> perf record -g <the program I have to profile>
>>>
>>> And in another window, I start 200 threads of the load generator
>>> (which is not recorded by perf)
>>>
>>> This generates me statistics that I expect to see, and I am happy. As
>>> this is academia and a class assignment, I need to collect information
>>> and analyze it across different setups. Which of course meant I script
>>> this whole thing, which basically is
>>>
>>> for i in all possibilities
>>> do
>>> perf record -g <the program I have to profile> &
>>> WAITPID=$!
>>> for j in NR_THREADS
>>> do
>>> <start load generator> &
>>> KILLPID=$!
>>> done
>>> wait $PID
>
> You meant $WAITPID, right?
>

yes. grrr. I changed the name here to WAITPID for it to be clear and
that was a fail. (I blame the cold)

>
>>> kill $KILLPID
>
> Doesn't it kill the last load generator only?
>
>

Well, this was a bug in me typing the pseudo code. the actual script
does "$KILLPID $!"

Dhaval
