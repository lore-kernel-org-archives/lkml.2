Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab2ILBYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:24:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54168 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2ILBYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:24:47 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-48-504fe45c35b3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/18] perf test: Remove die() calls
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
	<1347407590-30960-2-git-send-email-acme@infradead.org>
	<87627kay0u.fsf@sejong.aot.lge.com>
	<20120912010310.GA10019@ghostprotocols.net>
Date: Wed, 12 Sep 2012 10:17:51 +0900
In-Reply-To: <20120912010310.GA10019@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 11 Sep 2012 18:03:10 -0700")
Message-ID: <87sjao9gzk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012 18:03:10 -0700, Arnaldo Carvalho de Melo wrote:
> Em Wed, Sep 12, 2012 at 09:24:33AM +0900, Namhyung Kim escreveu:
>> Hi, Arnaldo
>> 
>> On Tue, 11 Sep 2012 20:52:53 -0300, Arnaldo Carvalho de Melo wrote:
>> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
>> >
>> > Just use pr_err() + return -1 and let the other tests run as well and
>> > then the perf's main() exit doing whatever it needs.
>> [snip]
>> > diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
>> > index cf33e50..6ae102e 100644
>> > --- a/tools/perf/builtin-test.c
>> > +++ b/tools/perf/builtin-test.c
>> > @@ -1023,14 +1023,16 @@ static int __test__rdpmc(void)
>> >  
>> >  	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
>> >  	if (fd < 0) {
>> > -		die("Error: sys_perf_event_open() syscall returned "
>> > -		    "with %d (%s)\n", fd, strerror(errno));
>> > +		pr_debug("Error: sys_perf_event_open() syscall returned "
>> > +			 "with %d (%s)\n", fd, strerror(errno));
>> 
>> s/pr_debug/pr_err/ ?
>> 
>> Otherwise the message will not be shown unless -v option is given
>> - and it's not sync with the changelog ;-)
>
> Oops :-\ Can you sent a fixup patch for this and the other case?

Will send it right soon.

Thanks,
Namhyung
