Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0KZTWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:22:09 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35830 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab0KZTWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:22:07 -0500
Message-ID: <4CF008D8.2020609@linux.vnet.ibm.com>
Date: Fri, 26 Nov 2010 11:22:00 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to "perf
 stat"
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com> <1290666760.2072.539.camel@laptop>
In-Reply-To: <1290666760.2072.539.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 10:32 PM, Peter Zijlstra wrote:
> On Wed, 2010-11-24 at 17:54 -0800, Corey Ashford wrote:
>> Add the ability to create multiple event groups, each with their own leader
>> using the existing "-e<event>[,<event>  ...] [-e<event>[,<event>]]"
>> syntax.  Each additional -e switch creates a new group, and each event
>> listed within a -e switch is within that group.
>>
>> Changes since v1:
>> - Because of a flub, v2 did not contain the changes I had intended to make,
>> and instead, v2 had the same patch contents as v1.
>> - When perf stat is not supplied any events on the command line, put
>> each default event in its own group.
>
> I like this, but could you also extend this to perf-record? its a bit
> odd to diverge between the two.
>
> Using Stephane's latest syntax changes you could actually do something
> like:
>
> perf record -e task-clock:freq=1000,cycles:period=0
>
> Which would create a group with 1 sampling counter and a counting
> counter (at which point we should probably start flipping
> PERF_SAMPLE_READ).

Yes, that would be useful.

>
> Matt was working on supporting that (although not through cmdline
> syntax) and teaching perf-report to cope with such output.

I did briefly consider adding this capability to perf record, but I knew 
it would be a lot more complicated.

This perf stat capability is something we added to an internal version, 
and have been using it for more than 6 months.   It's quite helpful for 
verifying that the kernel code for an arch is implemented correctly.

As an alternative approach, how about if instead of changing the 
existing syntax to perf stat, I instead add a -g/--group option which 
takes groups of events?

That way we won't really be diverging perf record and perf stat; we'll 
just have a feature that can at some point later in time be added to 
perf record when all of the details are worked out.

- Corey
