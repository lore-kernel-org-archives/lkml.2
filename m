Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2BUBOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:14:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19612 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2BUBOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:14:30 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=DJDFx9YhIQoErPJ5c-cA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329786868.25686.50.camel@gandalf.stny.rr.com>
Subject: Re: RAS trace event proto
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Tony Luck <tony.luck@intel.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 20 Feb 2012 20:14:28 -0500
In-Reply-To: <20120220145920.GB5728@aftab>
References: <20120220145920.GB5728@aftab>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 15:59 +0100, Borislav Petkov wrote:

> * I'd like to have conditional printk-ing in trace_mce_record depending
> on the TP args, Steve probably knows what can be done:

/me is confused :-)

> 
> @Steven:
> 
> I'd like to do the following:
> 
> 	TP_printk("%s, ARG1: %d, ARG2: %c ...", str1, arg1, arg2)
> 
> and have it print only the first arg, i.e. the string and drop the rest
> of the args while still doing the TP_fast_assign into the ring buffer
> and carrying the stuff to its consumers. Background is that I want to
> dump the decoded string of a hardware error, if it is decoded, but carry
> the MCE info to userspace and only dump the fields of the MCE if I
> haven't managed to decode it, i.e. str1 == "".
> 
> So, my question is, can I do something like:
> 
> 	TP_printk("%s, ARG1: %d, ARG2: %c ...", __print_conditional(str1, arg1, arg2))

You want to affect the output of ftrace?

perf and even trace-cmd do the parsing later and can be overridden.
Well, perf can be when we finally get it to use the updated trace-cmd
parser.

-- Steve

> 
> where __print_conditional is a vararg macro which calls a
> ftrace_print_cond() which prints only str1 if strlen(str1) > 0 and
> otherwise calls a vsnprintf() variant to deal with the va_args?
> 


