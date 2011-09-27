Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1I0CiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:38:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54841 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1I0CiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:38:00 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=gtOWHpAUYCwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=kIjrna13km2bGLLR81AA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC PATCH 1/2] PM/runtime: introduce trace points for tracing
 rpm_* functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: rjw@sisk.pl, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com
Date: Mon, 26 Sep 2011 22:37:53 -0400
In-Reply-To: <CACVXFVN33diJAa3yZ4ASuRD+5edDnBcAA-oBntW9k8RpdQOo2w@mail.gmail.com>
References: <1316664701-15273-1-git-send-email-tom.leiming@gmail.com>
	 <1317044445.26514.5.camel@gandalf.stny.rr.com>
	 <CACVXFVPQokm21c+do5+DaOvUAme2LaNiwrNw_Tm66KuOxPb1jA@mail.gmail.com>
	 <1317085894.26514.26.camel@gandalf.stny.rr.com>
	 <CACVXFVN33diJAa3yZ4ASuRD+5edDnBcAA-oBntW9k8RpdQOo2w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317091075.26514.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 09:45 +0800, Ming Lei wrote:

> > Not to mention, this will never work with tools such as perf or
> > trace-cmd, that will just get a pointer address and will try to read a
> > string that points inside the kernel.
> 
> Ok, sounds like dev_name does not work for the case, I will update
> the patch, but I am wondering why no such problem for dev_dbg?
> printk still may buffer these for sometime in some cases.
> 


printk will push out to the console immediately. Whatever is in the
buffer has already been processed into a string. With tracing, we save
the data as defined by TP_fast_assign() and is printed later when the
user asks in TP_printk().

> >
> > This will only work with reading the trace data
> > from /debug/tracing/trace, but not from any tools. The pS *will* work
> > with the tools as the tools load the kallsyms data, and is smart enough
> > to figure this pointer out.
> 
> __func__ points to a const string, which will be stored in kernel global
> read-only section, I think perf can read correct string from the pointer
> anytime, don't I?

That would be very dangerous to let a userspace app have any access to
reading the kernel memory. Not to mention, this data may be sent out
over the network to another machine, which must be able to read this
data too.

-- Steve


