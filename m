Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab2FMDFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:05:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49134 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2FMDFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:05:47 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-4d-4fd8038941d8
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	<1339486959-25241-4-git-send-email-namhyung@kernel.org>
	<1339524114.13377.140.camel@gandalf.stny.rr.com>
Date: Wed, 13 Jun 2012 12:02:51 +0900
In-Reply-To: <1339524114.13377.140.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Tue, 12 Jun 2012 14:01:54 -0400")
Message-ID: <87ehpj6hic.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 12 Jun 2012 14:01:54 -0400, Steven Rostedt wrote:
> On Tue, 2012-06-12 at 16:42 +0900, Namhyung Kim wrote:
>> +int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
>> +		    char *buf, size_t buflen)
>
> Hmm, actually I wonder if we should put the error into the pevent
> structure. Then we wouldn't even need to waste time to pass the data
> through.
>
> That is, you can simply do:
>
> 	ret = pevent_foo();
> 	if (ret < 0) {
> 		pevent_strerr(pevent, buf, buflen);
> 		printf("%s\n", buf);
> 	}
>
> Perhaps even include a pevent_perror(), to just do:
>
> 	if (ret < 0) {
> 		pevent_perror(pevent);
> 		return ret;
> 	}
>

I thought something like this, but worried about the thread-safety. What
about if more than one thread call pevent functions for a same pevent
concurrently?  Should we make the pevent->errno TLS?

Thanks,
Namhyung
