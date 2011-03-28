Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab1C1KM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:12:59 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55137 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1C1KM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:12:58 -0400
X-AuditID: b753bd60-9c553ba000007e19-48-4d905f26cdd1
X-AuditID: b753bd60-9c553ba000007e19-48-4d905f26cdd1
Message-ID: <4D905F24.3050100@hitachi.com>
Date: Mon, 28 Mar 2011 19:12:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, mingo@elte.hu,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Matt Fleming <matt@console-pimps.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC] perf: EBNF for event syntax
References: <1300851416.31224.58.camel@minggr.sh.intel.com>	 <1301051277.2250.195.camel@laptop>  <4D901F58.4060902@hitachi.com> <1301299090.4859.6.camel@twins>
In-Reply-To: <1301299090.4859.6.camel@twins>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/28 16:58), Peter Zijlstra wrote:
> On Mon, 2011-03-28 at 14:40 +0900, Masami Hiramatsu wrote:
>> (2011/03/25 20:07), Peter Zijlstra wrote:
>>> On Wed, 2011-03-23 at 11:36 +0800, Lin Ming wrote:
>>>> Hi, all
>>>>
>>>> On Thu, Mar 17, 2011 at 2:02 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>>>> How about we start writing proper EBNF syntax rules for this stuff, its
>>>>> getting seriously out of hand.
>>>> http://marc.info/?l=linux-kernel&m=130029871318866&w=2
>>>>
>>>> As Peter suggested, I wrote a simple EBNF for event syntax, as below.
>>>> My first plan is to pass in extra config value for some events,
>>>> for example, offcore response and load latency.
>>>>
>>>> perf record -e r100b(0004):p
>>>>
>>>> As above, the extra config value 0004 is passed in the parentheses.
>>>>
>>>> The EBNF
>>>> ========
>>>>
>>>> EventList		:=	Event [',' EventList]
>>>
>>> There was a suggestion a while back to make:
>>>
>>>  -e ev1,ev2,ev3
>>>
>>> create an event group with ev2 and ev3 siblings of ev1, and have
>>> multiple -e instances create separate counters.
>>>
>>> The problem is that its not backwards compatible, but something like
>>> that would still be very nice to have.
>>
>> I doubt that we really need to define those events are
>> grouped at recording time, because group(event ratio)
>> analysis must be done at analysis time(report etc.)
> 
> Uhm, grouping isn't at all related to event ratios, you can do event
> ratios just fine without groups - there's some stronger correlation when
> you do ratios with groups, but since its all statistics anyway, you can
> get that same extra correlation by simply running longer too.
> 
> Groups are most useful in measuring events on another base, which is
> basically mandatory if your primary event doesn't have sampling support
> itself.

Ah, OK, there are some arch/events don't have a sampling mode.
If I understand it correctly, how about below syntax?

-e (ev2,ev3)/ev1

This create an event group with ev2 and ev3 siblings of ev1 (and
ev1 gives sampling base).

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
