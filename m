Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab2KMBUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:20:36 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57868 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2KMBUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:20:34 -0500
X-AuditID: 9c93016f-b7b42ae000004383-dc-50a1a05e6ac5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Vinson Lee <vlee@twitter.com>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
	<87390fo9jn.fsf@sejong.aot.lge.com>
	<20121112135545.GA4595@krava.brq.redhat.com>
	<20121112160139.GC18978@ghostprotocols.net>
Date: Tue, 13 Nov 2012 10:20:30 +0900
In-Reply-To: <20121112160139.GC18978@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 12 Nov 2012 13:01:39 -0300")
Message-ID: <87txsumh7l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 13:01:39 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 12, 2012 at 02:55:46PM +0100, Jiri Olsa escreveu:
>> On Mon, Nov 12, 2012 at 11:10:52AM +0900, Namhyung Kim wrote:
>> > On Fri,  9 Nov 2012 18:42:49 -0300, Arnaldo Carvalho de Melo wrote:
>> > > . Add a 'link' method for hists, so that we can have the leader with
>> > >   buckets for all the entries in all the hists.  This new method
>> > >   is now used in the default 'diff' output, making the sum of the 'baseline'
>> > >   column be 100%, eliminating blind spots. Now we need to use this
>> > >   for 'diff' with > 2 perf.data files and for multi event 'report' and
>> > >   'annotate'.
>
>> > I'm not sure it can be used for group report at least in its current
>> > form.  IIUC it connects multiple hist entries using a list head and
>> > create a dummy entry in the leader if need be.  But it didn't handle
>> > non-leader entries so it's hard to tell which is which if less entries
>> > are present only.  For example consider following case:
>
>> > 	leader		member1		member2
>> > 	A		A		A
>> > 	B
>> > 			C
>> > 					D
>
>> > where leader, member1 and member2 are evsel/hists and A, B, C and D are
>> > hist entries.  After 'linking' the entries the leader will have
>> > following linkage:
>
>> > 	leader
>> > 	A	->	A	->	A
>> > 	B
>> > 	C (dummy) ->	C
>> > 	D (dummy)		->	D
>
>> > In this case, for entry A the leader can determine which entry came from
>> > which hists by looking its order in the list.  For entry B the leader
>> > can use zero value for them since the list is empty.  However for
>> > entries C and D, it cannot know which one is the right hists unless it
>> > records a hist index or creates dummy entry and insert it in a correct
>> > order (looks far from an optimal solution).  Am I missing something?
>
>> there's hists pointer in hist_entry if that's what you look for
>
> And from there to evsel->idx. In your patchset you even introduce
> hists_2_evsel(), right?

Ah, okay.  I worried about a possiblity of non-consecutive event groups
for some reason, but that's not gonna happen in the future?

Thanks,
Namhyung
