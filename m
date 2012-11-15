Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993134Ab2KOIxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:53:52 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45721 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993251Ab2KOIvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:51:32 -0500
X-AuditID: 9c93016f-b7b42ae000004383-6d-50a4ad123777
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/5] perf ui/gtk: Separate out GTK codes to a shared object
References: <1352911664-24620-1-git-send-email-namhyung@kernel.org>
	<alpine.LFD.2.02.1211150942260.2386@tux.localdomain>
Date: Thu, 15 Nov 2012 17:51:30 +0900
In-Reply-To: <alpine.LFD.2.02.1211150942260.2386@tux.localdomain> (Pekka
	Enberg's message of "Thu, 15 Nov 2012 09:43:07 +0200 (EET)")
Message-ID: <87wqxnl04t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012 09:43:07 +0200 (EET), Pekka Enberg wrote:
> On Thu, 15 Nov 2012, Namhyung Kim wrote:
>> This is an RFC patchset to separate GTK GUI codes to a shared object,
>> called libperf-gtk.so and use it with libdl.  It's in an early-stage
>> so probably has some rough edges, but I'd like to get some comments.
>> 
>> For now, the libperf-gtk.so (I'm open to a better name suggestion)
>> contains whole libperf.a and libtraceevent.a for simplicity.  And
>> because of that, every single object in perf tools needs to be built
>> as a PIC like libtraceevent does.
>> 
>> As a result, library dependency of the perf itself reduced like this:
>
> [snip]
>
>> To run GTK report browser, you can do it with usual --gtk option but
>> you might need to setup LD_LIBRARY_PATH.
>> 
>>   $ LD_LIBRARY_PATH=$PWD ./perf report --gtk
>> 
>> Missing LD_LIBRARY_PATH will lead to a fallback TUI or stdio (for 
>> NO_NEWT=1 build) report browser.
>
> What's the benefit of doing this? Requiring users to specify 
> LD_LIBRARY_PATH seems like a major PITA.

Nothing. ;-)  

It should be installed to a proper place - I just missed to do it before
sending it.  And with this RFC patches, I wanted to be confirmed that I
was going to the right direction before doing something silly. :)

Thanks,
Namhyung
