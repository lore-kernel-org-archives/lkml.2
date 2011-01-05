Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab1AEDKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:10:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37084 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1AEDKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HWG5ICy/MRcotv4rJixC0q/WXyGJ4geKbI9kXJg5RsB3sgbErFSokLCmHHbMf4WK2v
         9We7WJ4DRGyyKjVXocrYbe3XmzL8BinAWGowCpILoDmsGO473rs4aNsyE0LGSpzkHlZS
         GjlhqbCPBw4FVvlkjpGExM6QBgs615T0S9PDE=
Date: Wed, 5 Jan 2011 04:10:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 3/5] ftrace trace event add missing semicolumn
Message-ID: <20110105031016.GI2911@nowhere>
References: <20110104231629.996422888@efficios.com>
 <20110104232419.441463699@efficios.com>
 <20110105000005.GE2911@nowhere>
 <20110105001837.GA9737@Krystal>
 <20110105020759.GG2911@nowhere>
 <12932.1294196493@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12932.1294196493@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 10:01:33PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 05 Jan 2011 03:08:02 +0100, Frederic Weisbecker said:
> > On Tue, Jan 04, 2011 at 07:18:37PM -0500, Mathieu Desnoyers wrote:
> 
> > > > > --- linux-2.6-lttng.orig/include/trace/ftrace.h
> > > > > +++ linux-2.6-lttng/include/trace/ftrace.h
> > > > > @@ -69,7 +69,7 @@
> > > > >  #undef DEFINE_EVENT
> > > > >  #define DEFINE_EVENT(template, name, proto, args)	\
> > > > >  	static struct ftrace_event_call	__used		\
> > > > > -	__attribute__((__aligned__(4))) event_##name
> > > > > +	__attribute__((__aligned__(4))) event_##name;
> 
> > > Adding this semicolumn here ensures that all Ftrace macros are consistent wrt
> > > semicolumns. We can get away without consistency currently exactly because the
> > > current scheme adds many useless semicolumns between each TRACE_EVENT().
> 
> > Are you sure you want to put so much time on this?
> 
> > This will require a massive change for the sole win of removing double ";"
> > in generated code. This won't optimize much the build, and it will make the things
> > not so much more readable for very rare people who dare to have interest into the
> > TRACE_EVENT generated code. That notwithstanding the obfuscation of that generated
> > code resides more in the lack of indentation and newlines than in double
> > semicolons that we barely notice.
> 
> Can DEFINE_EVENT ever be sensibly used in a context where the additional ; will
> cause an issue (for instance, a hypothetical array initialization like:
> 
> static struct events[] = {DEFINE_EVENT(..), DEFINE_EVENT(...) }

You can't do the above as DEFINE_EVENT() do more than just creating a structure.
It can define functions and so.

Plus it doesn't behave the same whether CREATE_TRACE_POINTS is defined or not:
it can either define or declare the functions and structures.
 
> or other places we usually do the 'do { X } while (0)' trick to make the code legal?

I just can't figure out a sane case.

