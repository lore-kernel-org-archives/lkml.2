Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab0DSWEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:04:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61638 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab0DSWEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bUgH6cysnYTxPjkKw//dHvXQbz4FSTpQT/eEnvWNheRDGmUpf1VW03pmXgtZuW4AQo
         pzwiNejOkhD4uI9rxm2hajMvG1RLasviQN0xLIscaFLC2F8dt7dzjpHZtRWniAEtn6aL
         Oqpy7+I/SbfyUyxhfYCi0P+pQhH0q3jMXua4A=
Date: Tue, 20 Apr 2010 00:04:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: request to add trace off and trace on with events
Message-ID: <20100419220437.GC8811@nowhere>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com> <4BCCBF6D.3030105@am.sony.com> <1271709846.10448.29.camel@gandalf.stny.rr.com> <20100419212950.GB8811@nowhere> <1271713074.10448.101.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271713074.10448.101.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 05:37:54PM -0400, Steven Rostedt wrote:
> On Mon, 2010-04-19 at 23:29 +0200, Frederic Weisbecker wrote:
> 
> > The problem with having triggers defined in the filter file is that
> > you couldn't set a normal filter plus a trigger.
> > 
> > That said a filter itself could be a trigger.
> > 
> > if (cond) filter
> > 
> > This is going to break some ABI though.
> > 
> > In fact having one file per trigger type is going to make the
> > things much easier if you don't want to encumber with syntax parsing,
> > and just reuse the filtering code as is with very few modification.
> > This is going to be also easier for the users as they don't have to
> > remember the syntax or the available triggers.
> > 
> > Say you are in an event directory:
> > 
> > $ ls triggers/
> > 
> > filter
> > tracing_off
> > tracing_on
> > dump_trace
> > 
> > $ echo "(a == 1 && b == 2)" > tracing_off
> > 
> > So in the above example, you just reuse the filtering code,
> > no need to parse an if or a command.
> > The filter becomes a command. I've listed it in the triggers
> > directory but this just to express the fact it can be treated
> > like whatever trigger command, this is just an implementation
> > POV. In fact we can just keep it in the event directory.
> 
> 
> I like this. Heck, all registered triggers can be shown here.
> 
> # cat event/sched/sched_switch/triggers/tracing_off
> disabled
> 
> Or it can be a filter, or enabled.


Yep, since it would share exatly the same code than filter (as
filter basically becomes a trigger command), it can behave the
same: displaying "none" when there is no filter, or a filter.


> 
> This could also allow a user to do:
> 
> echo "(a > 100)" > tracing_on
> echo "(a < 100)" > tracing_off


Yeah :)
But if the scope of the "tracing off" is only for this event, then
rather use:

echo "(a < 100)" > filter

You could have tracing_off/on that have this event scope and
tracing_off/on_all for a global tracing scope.

