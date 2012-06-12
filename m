Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2FLGE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:04:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54741 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2FLGE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:04:27 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-db-4fd6dbe8e2a0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] perf sched replay: fix event lookup
References: <1339232758-920-1-git-send-email-dmitry.antipov@linaro.org>
	<87pq96pfj9.fsf@sejong.aot.lge.com>
	<20120611140852.GB2202@infradead.org>
Date: Tue, 12 Jun 2012 15:01:26 +0900
In-Reply-To: <20120611140852.GB2202@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 11 Jun 2012 11:08:52 -0300")
Message-ID: <8739616pc9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 11 Jun 2012 11:08:52 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jun 11, 2012 at 02:46:02PM +0900, Namhyung Kim escreveu:
>> On Sat,  9 Jun 2012 13:05:58 +0400, Dmitry Antipov wrote:
>> > Use new function trace_find_event_by_name to lookup events before
>> > looking through /sys files. This helps 'perf sched replay' to map
>> > event names to IDs correctly when processing perf.data recorded
>> > on another machine.
>> 
>> Basically the same approach with the previous reply, please put this
>> into trace_event__id(). And minor nits below..
>
> Well, trace_event__id() is private to evlist and evlist so far is a
> local thing, i.e. it doesn't know anything about perf.data files.
>

Really? I see that perf_session__open make up an evlist for the session
and a tracepoint event in the evlist should look up the perf.data
first. As this patch addressed, perf sched replay dealt with the
session->evlist already. Am I missing something?


> So I think we should have a per perf.data (perf_session) method that
> knows that it shouldn't look _at all_ to /sys, but just at what came in
> the perf.data file.
>

Fair enough. The method should be a simple wrapper to libtraceevent APIs
like this patch.


> As well when we want something that is on the running machine, even if
> we're dealing somehow with a perf.data file, we shouldn't use what is in
> it.
>

That's the current behavior of the trace_event__id(). Do you want to
make it public?

Thanks,
Namhyung
