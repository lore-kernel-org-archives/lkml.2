Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2HIRYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:24:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55679 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab2HIRYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:24:30 -0400
Message-ID: <5023F24A.7030300@gmail.com>
Date: Thu, 09 Aug 2012 11:24:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf tools: Initial bash completion support
References: <1344522713-27951-1-git-send-email-fweisbec@gmail.com> <1344522713-27951-2-git-send-email-fweisbec@gmail.com> <20120809163515.GA4084@infradead.org> <5023E7F3.8090701@gmail.com> <20120809171419.GC4084@infradead.org>
In-Reply-To: <20120809171419.GC4084@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/12 11:14 AM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Aug 09, 2012 at 10:40:19AM -0600, David Ahern escreveu:
>> On 8/9/12 10:35 AM, Arnaldo Carvalho de Melo wrote:
>>> Em Thu, Aug 09, 2012 at 04:31:51PM +0200, Frederic Weisbecker escreveu:
>>>> This implements bash completion for perf subcommands such
>>>> as record, report, script, probe, etc...
>>>
>>> Humm, I get this when doing my usual workflow:
>>>
>>> [acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
>>> make: Entering directory `/home/git/linux/tools/perf'
>>> PERF_VERSION = 3.6.rc1.152.g5758f7
>>> <SNIP>
>>> install -d -m 755 '/home/acme/libexec/perf-core/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
>>> install -d -m 755 '/home/acme/libexec/perf-core/scripts/python/bin'
>>> install scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '/home/acme/libexec/perf-core/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
>>> install scripts/python/*.py -t '/home/acme/libexec/perf-core/scripts/python'
>>> install scripts/python/bin/* -t '/home/acme/libexec/perf-core/scripts/python/bin'
>>> install -m 755 bash_completion /etc/bash_completion.d/perf
>>> install: cannot create regular file `/etc/bash_completion.d/perf': Permission denied
>>> make: *** [install] Error 1
>>> make: Leaving directory `/home/git/linux/tools/perf'
>>> [acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
>>>
>>> 	Shouldn't it install on ~/etc/bash_completion.d/perf ?
>>>
>>> 	Is there a way to have per user bash completion files like that?
>>
>> 3rd patch should fix this.
>
> Huh? The problem is not /etc/bash_completion.d/ not existing, it exists,
> its just that I'm not using sudo nor installing as root, this new bash
> completion file is the only one that is being installed on the root
> filesystem, all others are in ~acme/

3rd patch uses sysconfdir_SQ instead of /etc.

ifndef DESTDIR
prefix = $(HOME)
endif
...

ifeq ($(prefix),/usr)
sysconfdir = /etc
ETC_PERFCONFIG = $(sysconfdir)/perfconfig
else
sysconfdir = $(prefix)/etc
ETC_PERFCONFIG = etc/perfconfig
endif

So, sysconfdir should be set to $(HOME)/etc in your case.

