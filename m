Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab2BMTTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:19:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49223 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab2BMTTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:19:42 -0500
Message-ID: <4F396249.2050001@gmail.com>
Date: Mon, 13 Feb 2012 12:19:37 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] perf tools: Introduce struct perf_maps_opts
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com> <1329118064-9412-2-git-send-email-namhyung.kim@lge.com> <20120213183232.GD15955@infradead.org> <4F395B75.4060800@gmail.com> <20120213190542.GL15955@infradead.org>
In-Reply-To: <20120213190542.GL15955@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/13/2012 12:05 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Feb 13, 2012 at 11:50:29AM -0700, David Ahern escreveu:
>> The cleanup might make my multiple tid/pid patch easier: e.g.,
>>
>> struct perf_target{
>> 	...
>> 	char errmsg[128];
>> };
>>
>> Then if the tid/pid string parsing fails in perf_evlist__create_maps and
>> friends the errmsg can be put into the buffer for the callers to get a
>> more useful message to the user as to what happened.
>>
>> Today's perf if you give it an invalid pid, scandir fails and the
>> command spits out the usage statement. Which is completely confusing --
>> ie., not clear that the command failed b/c the pid does not exist.
> 
> Humm, ok, but then I think we should have an enum + a strerror(3)
> equivalent, i.e.:
> 
> 	enum perf_target_error perf_evlist__create_maps(...);
> 
> 	int perf_target__strerror(struct perf_target *target, int errnum,
> 				  char *buf, size_t buflen);

ok, so you are proposing an internal generation of enum error codes and
correlating them to strings rather than adding a buffer into
perf_target. If that's the case perhaps we need a libperf-wide design:

enum perf_error
perf__strerror(enum perf_error)

which effectively taps an array similar to _sys_errlist_internal based
on enum index.

> 
> Please see 'man strerror_r", and make it work like the POSIX compliant
> variant.

No globals are in use, so I would expect the _r to be redundant. I have
glibc source; scanning __strerror_r implementation ....

> 
> Ok, so it may be better to first process Kim's patches and then you
> rework yours?

The current patch is ready to go; I just don't like the error handling
and lack of a useful message. That said, it is no worse than what
happens today.

David

> 
> - Arnaldo
