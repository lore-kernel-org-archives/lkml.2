Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab1CIQlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:41:08 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:58045 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab1CIQlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:41:04 -0500
Message-ID: <4D77AD9C.4080407@dcl.info.waseda.ac.jp>
Date: Thu, 10 Mar 2011 01:41:00 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b10pre) Gecko/20110114 Thunderbird/3.3a2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: clean the options for perf record
References: <1298389415.2217.243.camel@twins> <20110222182206.GB1799@nowhere> <4D648A65.2040107@dcl.info.waseda.ac.jp> <4D667D60.5010903@dcl.info.waseda.ac.jp> <20110224165014.GB1840@nowhere> <4D67E286.8010907@dcl.info.waseda.ac.jp> <AANLkTikUGO=Obm7Ue4VzEueQ7DERPiwci1VV9NmKZf1u@mail.gmail.com> <4D70B3E1.8020108@dcl.info.waseda.ac.jp> <20110304135635.GB1972@nowhere> <1299247099.24454.3.camel@twins> <20110304142113.GC1972@nowhere>
In-Reply-To: <20110304142113.GC1972@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年03月04日 23:21, Frederic Weisbecker wrote:
> On Fri, Mar 04, 2011 at 02:58:19PM +0100, Peter Zijlstra wrote:
>> On Fri, 2011-03-04 at 14:56 +0100, Frederic Weisbecker wrote:
>>> lockstat is a global measurement since the boot.
>>
>> You can reset lockstat at any given time.
>
> Event though, that's still a global profiling. You can't have a per
> process or thread granularity.
>
> Or even more precise context for some future feature in perf that
> I have in mind and would like to implement soon, like counting/sampling
> an event only between two others. More exactly having two lists for
> each event:
>
> * activate
> * deactivate
>
> Those on the first list activate the target event when they overflow. (->start() )
> Those on the second list deactivate .... (->stop() )
>
> With events in activate and deactivate in the same context than the target,
> locking and permissions should be kept simple. Locking especially shouldn't be
> needed in the fast path. Then if that's needed we could think about a cross
> context things later.
>
> Plus an attr->start_state that decides if the first ->add() made is made
> with PERF_EF_STAT or not. (We then need to keep track of some activated/deactivated
> state across schedules).
>
> That's in fact the exclude_irq and exclude_softirq idea extended to any kind
> of existing event.
>

Do you mean that the event dropping in perf_tp_event_match() should be
extended for filtering hardirq and softirq? If so, it seems good.
I'd like to measure the effectiveness of it.
