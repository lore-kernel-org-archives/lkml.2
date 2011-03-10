Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1CJAbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:31:46 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:55396 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1CJAbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:31:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABird02rR7Hu/2dsb2JhbACmcnSmfJw5hWUEhSKHGINIgiM
X-IronPort-AV: E=Sophos;i="4.62,293,1297036800"; 
   d="scan'208";a="413230408"
Message-ID: <4D781C16.3080706@cisco.com>
Date: Wed, 09 Mar 2011 17:32:22 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 07/10] perf script: Move printing of 'common' data from
 print_event and rename
References: <1299695491-15786-1-git-send-email-acme@infradead.org> <1299695491-15786-8-git-send-email-acme@infradead.org> <20110309235007.GB2533@nowhere> <4D78158F.6010403@cisco.com> <20110310001039.GC2533@nowhere> <4D78174B.2090209@cisco.com> <20110310002240.GE2533@nowhere>
In-Reply-To: <20110310002240.GE2533@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/09/11 17:22, Frederic Weisbecker wrote:
> On Wed, Mar 09, 2011 at 05:15:00PM -0700, David Ahern wrote:
>>
>>
>> On 03/09/11 17:10, Frederic Weisbecker wrote:
>>>
>>> And if you actually keep those functions in place?
>>
>>     CC /tmp/build-perf/util/trace-event-read.o
>> cc1: warnings being treated as errors
>> util/trace-event-parse.c:2652:13: error: 'print_graph_cpu' defined but
>> not used
>> util/trace-event-parse.c:2681:13: error: 'print_graph_proc' defined but
>> not used
>> make: *** [/tmp/build-perf/util/trace-event-parse.o] Error 1
>> make: *** Waiting for unfinished jobs....
> 
> All right, that's because you removed their calls in pretty_print_func_ent().
> So either you remove the whole in a specific patch, pretty_print_func_ent()
> included and other related functions, or you keep them.
> 
> But I prefer we don't do something halfway, and in particular not in a
> semi-hidden way inside a patch that is not particularly focused on that
> purpose.

You lost me on the halfway part.

So you want a separate patch that removes the code for an incomplete
feature -- which means changing the references to the functions in that
patch? The intent being a patch that can be reverted later?

What about the cpu argument which was only kept in print_trace_event to
avoid the removal of more code? Leave it and the additional code or take
it out?

David
