Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab2HHCXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 22:23:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58007 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2HHCX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 22:23:29 -0400
Message-ID: <5021CD9E.7060903@gmail.com>
Date: Tue, 07 Aug 2012 20:23:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Initial bash completion support
References: <1344358801-16383-1-git-send-email-fweisbec@gmail.com> <1344358801-16383-2-git-send-email-fweisbec@gmail.com> <5021926E.2070202@gmail.com> <87ipcuyys5.fsf@sejong.aot.lge.com>
In-Reply-To: <87ipcuyys5.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/12 7:10 PM, Namhyung Kim wrote:
> On Tue, 07 Aug 2012 16:10:54 -0600, David Ahern wrote:
>> On 8/7/12 11:00 AM, Frederic Weisbecker wrote:
>>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>>> index 35655c3..ddfb7e5 100644
>>> --- a/tools/perf/Makefile
>>> +++ b/tools/perf/Makefile
>>> @@ -951,6 +951,7 @@ install: all
>>>    	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
>>>    	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
>>>    	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
>>> +	$(INSTALL) -m 755 bash_completion $(DESTDIR_SQ)/etc/bash_completion.d/perf
>>
>> still getting an error here:
>>
>> $ make DESTDIR=/tmp/junk-perf O=/tmp/pbuild -C tools/perf/ install
>> ...
>> install -m 755 bash_completion /tmp/junk-perf/etc/bash_completion.d/perf
>> install: cannot create regular file
>> /tmp/junk-perf/etc/bash_completion.d/perf': No such file or directory
>> make: *** [install] Error 1
>> make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'
>
> Does patch below fix it?

Of course. I was too lazy to do that; one liner for Frederic to add - 
though the sysconfdir integration is nice.

David

