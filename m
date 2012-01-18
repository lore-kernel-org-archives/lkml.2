Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab2AREnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:43:22 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33587 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab2AREnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:43:21 -0500
X-Greylist: delayed 170404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 23:43:21 EST
X-AuditID: b753bd60-98392ba000007b1b-4b-4f164de639ff
X-AuditID: b753bd60-98392ba000007b1b-4b-4f164de639ff
Message-ID: <4F164DDA.1040507@hitachi.com>
Date: Wed, 18 Jan 2012 13:43:06 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v4 1/5] perf-script: unify the expressions indicate
 "unknown"
References: <20120116052146.2485.48349.stgit@linux3> <20120116052210.2485.80894.stgit@linux3> <20120117154902.GA15820@infradead.org>
In-Reply-To: <20120117154902.GA15820@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/18 0:49), Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 16, 2012 at 02:22:10PM +0900, Akihiro Nagai escreveu:
>> perf-script uses various expressions to indicate "unknown".
>> It is unfriendly for user scripts to parse it. So, this patch unifies
>> the expressions to "[unknown]".
>
>> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
>> @@ -118,6 +118,7 @@ void map__delete(struct map *self);
>>   size_t map__fprintf(struct map *self, FILE *fp);
>> +void map__print_dsoname(struct map *self);
>
> See map__fprintf(), everything that is for printing to a file like
> output has that form: last paramenter is a FILE pointer, then users do:
>
>     map__fprintf_dsoname(map, stdout);
>
> or to stderr, or to something else, like in cases where tools have a
> 'strace -o FILENAME' like switch, like 'perf stat --log-fd N':
>
>          OPT_INTEGER(0, "log-fd",&output_fd,
>                      "log output to fd, instead of stderr"),
>
> That uses fdreopen(output_fd), etc.
>
> So please convert these new __print_something methods to
> __fprintf_something(..., FILE *fp).
>
> Also please don't use 'self' anymore, that was a bad decision I made in
> perf's early ages and that Thomas Gleixner suggested we use more
> descriptive names such as, in the above case, 'map', i.e.:
>
>   void map__fprintf_dsoname(struct map *map, FILE *fp);
>
>> From time to time I convert these 'self' leftovers in areas where I
> notice that are not having too much coding activity, to avoid clashing
> with pending patches, so lets not add more in new code :)
I see. I'm going to fix and resend my patches,
e.g. map__print_dsoname(self) => map__fprintf_dsoname(map, fp)

Thank you.
>
> Thanks,
>
> - Arnaldo
