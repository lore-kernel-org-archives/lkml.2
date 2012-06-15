Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2FOWZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:25:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57767 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195Ab2FOWZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:25:11 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
In-Reply-To: <1339763971.13377.370.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Fri, 15 Jun 2012 08:39:31 -0400")
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	<1339486959-25241-4-git-send-email-namhyung@kernel.org>
	<1339763971.13377.370.camel@gandalf.stny.rr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
Date: Sat, 16 Jun 2012 07:25:02 +0900
Message-ID: <87k3z843i9.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Tue, 2012-06-12 at 16:42 +0900, Namhyung Kim wrote:
>
>> +/*
>> + * This must have a same ordering as the enum pevent_errno.
>> + */
>> +static const char * const pevent_error_str[] = {
>> +	"failed to allocate memory",
>> +	"failed to parse event",
>> +	"failed to read event id",
>> +	"failed to read event format",
>> +	"failed to read event print fmt",
>> +	"failed to allocate field name for ftrace",
>> +};
>> +
>
> Here's a little macro trick to keep the strings and enums always in
> sync:
>
> #define __PEVENT_ERRNO_CODES \
>  _C(PEVENT_ERRNO__MEM_ALLOC_FAILED,	"failed to allocate memory"),	\
>  _C(PEVENT_ERRNO__PARSE_EVENT_FAILED,	"failed to parse event"),	\
>  _C(PEVENT_ERRNO__READ_ID_FAILED,	"failed to read event id"),	\
>  _C(PEVENT_ERRNO__READ_FORMAT_FAILED,	"failed to read event format"),	\
>  _C(PEVENT_ERRNO__READ_PRINT_FAILED,	"failed to read event print fmt"),\
>  _C(PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace"),
>
> #undef _C
> #define _C(a,b) b
> static const char * const pevent_error_str[] = { __PEVENT_ERROR_CODES };
>

Cool. Maybe even shorter:

#define __PEVENT_ERRNO_CODES \
 _C(MEM_ALLOC_FAILED,	"failed to allocate memory"),	\
 _C(PARSE_EVENT_FAILED,	"failed to parse event"),	\
 _C(READ_ID_FAILED,	"failed to read event id"),	\
 _C(READ_FORMAT_FAILED,	"failed to read event format"),	\
 _C(READ_PRINT_FAILED,	"failed to read event print fmt"), \
 _C(OLD_FTRACE_ARG_FAILED, "failed to allocate field name for ftrace"),

#undef _C
#define _C(a,b) PEVENT_ERRNO__ ## a
static const char * const pevent_error_str[] = { __PEVENT_ERROR_CODES };

But it make them less grep-able?

Thanks,
Namhyung


> #undef _C
> #define _C(a, b) a
>
> enum pevent_errno {
> 	__PEVENT_ERRNO__BEFORE_START		= -100000 - 1,
> 	__PEVENT_ERRNO_CODES
> 	__PEVENT_ERRNO__END,
> };
>
> #define __PEVENT_ERRNO__START (__PEVENT_ERRNO__BEFORE_START + 1)
>
> Just saying ;-)
>
> -- Steve
