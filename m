Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab2JVHZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:25:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54512 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2JVHZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:25:26 -0400
X-AuditID: 9c930179-b7c8bae000003559-4c-5084f4e4ea3a
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] perf: Build install-man target when installing
References: <20120925174658.GD9320@aftab.osrc.amd.com>
	<1348854427-12746-1-git-send-email-bp@amd64.org>
	<20121020111625.GB17563@liondog.tnic>
Date: Mon, 22 Oct 2012 16:25:24 +0900
In-Reply-To: <20121020111625.GB17563@liondog.tnic> (Borislav Petkov's message
	of "Sat, 20 Oct 2012 13:16:25 +0200")
Message-ID: <87mwzfj7dn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 20 Oct 2012 13:16:25 +0200, Borislav Petkov wrote:
> On Fri, Sep 28, 2012 at 07:47:07PM +0200, Borislav Petkov wrote:
>> From: Borislav Petkov <borislav.petkov@amd.com>
>> 
>> There's a portion in the "perf list" output refering to the exact
>> specification of raw hardware events. Since this description is in
>> the perf-list manpage, make install-man be built unconditionally when
>> installing perf tool and change the reference in the "perf list" output
>> accordingly.
>> 
>> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>> ---
>>  tools/perf/Makefile            | 2 +-
>>  tools/perf/util/parse-events.c | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>> index 251dcd7fb5ac..e77741e22cfb 100644
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -1027,7 +1027,7 @@ perfexec_instdir = $(prefix)/$(perfexecdir)
>>  endif
>>  perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
>>  
>> -install: all
>> +install: all install-man

It will add additional dependencies of asciidoc, docbook-xsl and/or
something to default perf install command.  I don't know it matters
much, but just wanted to say.  What if a user want to install the perf
but the required packages for documents are not installed?


>>  	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
>>  	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
>>  	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
>> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
>> index bf5d033ee1b4..f84ac3984708 100644
>> --- a/tools/perf/util/parse-events.c
>> +++ b/tools/perf/util/parse-events.c
>> @@ -1092,7 +1092,7 @@ void print_events(const char *event_glob, bool name_only)
>>  		printf("  %-50s [%s]\n",
>>  		       "cpu/t1=v1[,t2=v2,t3 ...]/modifier",
>>  		       event_type_descriptors[PERF_TYPE_RAW]);
>> -		printf("   (see 'perf list --help' on how to encode it)\n");
>> +		printf("   (see 'man perf-list' on how to encode it)\n");

Is this needed?  Shouldn't we fix perf --help handling?  Please see my
other post on the issue.

Thanks,
Namhyung


>>  		printf("\n");
>>  
>>  		printf("  %-50s [%s]\n",
>> -- 
>> 1.7.11.rc1
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
