Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab2FOMjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:39:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab2FOMje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:39:34 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ag8JG7z7P3cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=CpiED0NXJNzBxhH2BZMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339763971.13377.370.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 15 Jun 2012 08:39:31 -0400
In-Reply-To: <1339486959-25241-4-git-send-email-namhyung@kernel.org>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	 <1339486959-25241-4-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 16:42 +0900, Namhyung Kim wrote:

> +/*
> + * This must have a same ordering as the enum pevent_errno.
> + */
> +static const char * const pevent_error_str[] = {
> +	"failed to allocate memory",
> +	"failed to parse event",
> +	"failed to read event id",
> +	"failed to read event format",
> +	"failed to read event print fmt",
> +	"failed to allocate field name for ftrace",
> +};
> +

Here's a little macro trick to keep the strings and enums always in
sync:

#define __PEVENT_ERRNO_CODES \
 _C(PEVENT_ERRNO__MEM_ALLOC_FAILED,	"failed to allocate memory"),	\
 _C(PEVENT_ERRNO__PARSE_EVENT_FAILED,	"failed to parse event"),	\
 _C(PEVENT_ERRNO__READ_ID_FAILED,	"failed to read event id"),	\
 _C(PEVENT_ERRNO__READ_FORMAT_FAILED,	"failed to read event format"),	\
 _C(PEVENT_ERRNO__READ_PRINT_FAILED,	"failed to read event print fmt"),\
 _C(PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace"),

#undef _C
#define _C(a,b) b
static const char * const pevent_error_str[] = { __PEVENT_ERROR_CODES };

#undef _C
#define _C(a, b) a

enum pevent_errno {
	__PEVENT_ERRNO__BEFORE_START		= -100000 - 1,
	__PEVENT_ERRNO_CODES
	__PEVENT_ERRNO__END,
};

#define __PEVENT_ERRNO__START (__PEVENT_ERRNO__BEFORE_START + 1)

Just saying ;-)

-- Steve




