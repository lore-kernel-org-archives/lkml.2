Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2FOAcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:32:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14365 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2FOAcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:32:03 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=G0s97Kyuy1EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=RQmxsZodu_biVuYzQrAA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339720321.13377.301.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Thu, 14 Jun 2012 20:32:01 -0400
In-Reply-To: <alpine.LFD.2.02.1206150154540.3086@ionos>
References: <alpine.LFD.2.02.1206142345100.3086@ionos>
	  <1339714725.13377.252.camel@gandalf.stny.rr.com>
	  <alpine.LFD.2.02.1206150106511.3086@ionos>
	 <1339717703.13377.285.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1206150154540.3086@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 02:00 +0200, Thomas Gleixner wrote:

>  commit 499e547057f5bba5cd6f87ebe59b05d0c59da905
>  Author: Steven Rostedt <srostedt@redhat.com>
>  Date:   Wed Feb 22 15:50:28 2012 -0500
> 
> Did you actually read what I wrote above?
> 
> > > That's still not an excuse for utter stupidity, really. Just check the
> > > commit date vs. your discovery time.
> 
> Emphasis on discovery time.
> 

Commit date was the local version. The pull request was March 14. It was
a hodge podge of updates that I pulled together. This could have been
where I pulled a stale branch. In fact, the fact that commit date was
Feb, and my push was almost a month later, could be exactly because I
grabbed the wrong branch :-/

Then most of my development goes on separate git branches. Sometimes I
rebase on top of tip and continue development, and sometimes I just
continue development on the branch I'm at and rebase when its done. It
may be months before I'm reusing code that I pushed out if the code I'm
working with is unrelated.

If this is an issue, I can change my work flow to always update to the
latest. Lately, I've actually been doing that. But a lot of time I just
work on my separate pieces, as they don't always have to do with each
other.

Since that change was submitted, I've pulled in and tested other
developers code, and did the 'remove stop machine with breakpoints'.
That code has been under development for about a year. And when it was
finally done, I even waited a few releases before pushing, and then only
pushing bits and pieces at a time.

Basically, yeah, the change went in in March, but I admit, I haven't
been developing with the latest code. A lot of the code I've been
working on is a year old, and the branches have not been updated to the
latest. June 6th came and Arnaldo asked for a feature in ftrace, and I
checked out a new branch based on latest tip. This was the first time I
encountered the bug.

I also use ftrace and tracing_off() extensively for work. But as we are
still on the 3.2-rt kernel, that would also keep me from seeing this as
well.

-- Steve


