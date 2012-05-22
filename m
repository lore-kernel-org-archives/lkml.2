Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2EVBKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:10:48 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52525 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2EVBK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:10:28 -0400
X-AuditID: 9c93016f-b7c3cae000001954-a4-4fbae7809016
From: Namhyung Kim <namhyung.kim@lge.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] perf symbols: Implement poor man's ELF parser
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
	<1336979424-17206-6-git-send-email-namhyung.kim@lge.com>
	<20120521114739.GC5923@m.brq.redhat.com>
Date: Tue, 22 May 2012 10:08:21 +0900
In-Reply-To: <20120521114739.GC5923@m.brq.redhat.com> (Jiri Olsa's message of
	"Mon, 21 May 2012 13:47:39 +0200")
Message-ID: <87wr4510qi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, again

On Mon, 21 May 2012 13:47:39 +0200, Jiri Olsa wrote:
> On Mon, May 14, 2012 at 04:10:24PM +0900, Namhyung Kim wrote:
>> Implement minimalistic elf parser for getting build-id.
>> A couple of structs needed are copied from elf.h and
>> the parser only looks for PT_NOTE program header to
>> check build-id.
>> ---
>>  tools/perf/util/elf-minimal.h    |  153 ++++++++++++++++++++++++
>>  tools/perf/util/symbol-minimal.c |  244 ++++++++++++++++++++++++++++++++++++--
>>  2 files changed, 388 insertions(+), 9 deletions(-)
>>  create mode 100644 tools/perf/util/elf-minimal.h
>> 
>> diff --git a/tools/perf/util/elf-minimal.h b/tools/perf/util/elf-minimal.h
>> new file mode 100644
>> index 000000000000..26540b5718a1
>> --- /dev/null
>> +++ b/tools/perf/util/elf-minimal.h
>> @@ -0,0 +1,153 @@
>> +/*
>> + * Minimal ELF definitions for parsing build-id.
>> + */
>> +/* This file defines standard ELF types, structures, and macros.
>> +   Copyright (C) 1995-2003,2004,2005,2006,2007,2008,2009,2010,2011
>> +	Free Software Foundation, Inc.
>> +   This file is part of the GNU C Library.
>> +
>> +   The GNU C Library is free software; you can redistribute it and/or
>> +   modify it under the terms of the GNU Lesser General Public
>> +   License as published by the Free Software Foundation; either
>> +   version 2.1 of the License, or (at your option) any later version.
>> +
>> +   The GNU C Library is distributed in the hope that it will be useful,
>> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> +   Lesser General Public License for more details.
>> +
>> +   You should have received a copy of the GNU Lesser General Public
>> +   License along with the GNU C Library; if not, write to the Free
>> +   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
>> +   02111-1307 USA.  */
>
> I can see all this exported in:
>
> [jolsa@dhcp-26-214 perf]$ rpm -qf /usr/include/elf.h
> glibc-headers-2.14.90-24.fc16.6.x86_64
>
> so maybe we dont need to add our own, since glic-headers
> seems crutial anyway ;)
>

Thanks for pointing it out. Actually I wanted to be independent to glibc
either, but it seems we tied to it tightly already. Will remove it.

Thanks,
Namhyung
