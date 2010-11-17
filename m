Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688Ab0KQNKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:10:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40765 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0KQNKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:10:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UiTuyIb3PCj6qtaS2nROxGd0r+/KKDaYCdTw5csMAO+7Ue0SLdqEHE+CTvJ0jFXN7s
         EqC/ejHeRuzQ+Dqa7iDxYclJs2Jq/hkllkVQRYJf6F/pA1BF6IKU4tp3itQvMA9crsDD
         uoRFOFWCB1ASHaPuzxQ2o57lvL27egXKW7zNU=
Date: Wed, 17 Nov 2010 14:10:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] trace: Add user-space event tracing/injection
Message-ID: <20101117131037.GD5464@nowhere>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu> <1289996994.2109.731.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289996994.2109.731.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 01:29:54PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 13:07 +0100, Ingo Molnar wrote:
> 
> > Subject: trace: Add user-space event tracing/injection
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Wed Nov 17 10:11:53 CET 2010
> > 
> > This feature (suggested by Darren Hart and Pekka Engberg) allows user-space
> > programs to print trace events in a very simple and self-contained way:
> > 
> >  #include <sys/prctl.h>
> >  #include <string.h>
> > 
> >  #define PR_TASK_PERF_USER_TRACE 35
> > 
> >  int main(void)
> >  {
> >          char *msg = "Hello World!\n";
> > 
> >          prctl(PR_TASK_PERF_USER_TRACE, msg, strlen(msg));
> > 
> >          return 0;
> >  }
> > 
> > These show up in 'trace' output as:
> > 
> >  $ trace report
> >  #
> >  # trace events of 'sleep 1':
> >  #
> >         testit/ 6006 ( 0.002 ms): <"Hello World!">
> >         testit/ 6006 ( 0.002 ms): <"Hello World!">
> > 
> > Suggested-by: Darren Hart <dvhart@linux.intel.com>
> > Suggested-by: Pekka Enberg <penberg@kernel.org>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> I really dislike abusing prctl(), I understand your reasons, but it
> still sucks.
> 
> Also, the naming doesn't work, you've implemented a trace event, that's
> got nothing to do with perf, so the PR_TASK_PERF_ prefix is incorrect.


Why not using write() on the perf event fd?
So that you don't only limit to a custom new simple event (which should
match most needs) but you can also inject whatever existing event you like.

