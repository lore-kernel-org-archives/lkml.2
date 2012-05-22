Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2EVBCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:02:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47769 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab2EVBCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:02:50 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-db-4fbae5b662ea
From: Namhyung Kim <namhyung.kim@lge.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] perf tools: Split out util/symbol-elf.c
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
	<1336979424-17206-4-git-send-email-namhyung.kim@lge.com>
	<20120521114531.GB5923@m.brq.redhat.com>
Date: Tue, 22 May 2012 10:00:43 +0900
In-Reply-To: <20120521114531.GB5923@m.brq.redhat.com> (Jiri Olsa's message of
	"Mon, 21 May 2012 13:45:31 +0200")
Message-ID: <871umd2fno.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri

On Mon, 21 May 2012 13:45:31 +0200, Jiri Olsa wrote:
> hi,
> this one needs rebase to current code, I got some conflicts
>

Will do.


> On Mon, May 14, 2012 at 04:10:22PM +0900, Namhyung Kim wrote:
>> Factor out the dependency of ELF handling into separate
>> symbol-elf.c file. It is a preparation of building a
>> minimalistic version perf tools which doesn't depend on
>> the elfutils.
>> 
>> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
>> ---
>>  tools/perf/Makefile          |    1 +
>>  tools/perf/util/symbol-elf.c |  691 +++++++++++++++++++++++++++++++++++++++++
>>  tools/perf/util/symbol.c     |  704 +-----------------------------------------
>>  tools/perf/util/symbol.h     |   15 +
>>  4 files changed, 715 insertions(+), 696 deletions(-)
>>  create mode 100644 tools/perf/util/symbol-elf.c
>> 
>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>> index e98e14c88532..7198c6cbc006 100644
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -334,6 +334,7 @@ LIB_OBJS += $(OUTPUT)util/usage.o
>>  LIB_OBJS += $(OUTPUT)util/wrapper.o
>>  LIB_OBJS += $(OUTPUT)util/sigchain.o
>>  LIB_OBJS += $(OUTPUT)util/symbol.o
>> +LIB_OBJS += $(OUTPUT)util/symbol-elf.o
>
> I think I'd like more generic elf interface compiled with either libelf
> or our stuff.. also separated from "other perf related" symbol handling
>
> looks like we need to be able to parse out build ID and symbols from
> symtab or dyntab:
>
> perf_elf__get_buildid(file, buf, len)
>
> perf_elf__get_symbols(file, ..., callback, )
>  - calling callback func for each symbol found,
>    the call would then do the perf symbol related stuff
>
> I understand that means much more changes.. so probably what you have now
> is a good start and we can do that later.. just with above goal in mind
>

So you mean we need to have our own libelf or such? I'm not sure it's
the way to go. I just wanted to have a working 'perf record' on my board
:). But I'd like to hear how others think.

Thanks for the comment,
Namhyung
