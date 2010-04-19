Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0DSV3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:29:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64709 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0DSV3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:29:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Sbu/wQqU6sEaEacBAcW1ATxWV+TD/QBmec4rigwBL4mTPCSHNx2WGbkJuRcsyCgOuI
         c+C4rMLcD3EexqQGDktQorZxQn0SVaU6VmcPl81p2lrwtQ8xXEmSjIeOpTMxV6OzvhT7
         R/y3J6T/tEum/fvp6+WeDaeCv3p4jvJ/HfxHU=
Date: Mon, 19 Apr 2010 23:29:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: request to add trace off and trace on with events
Message-ID: <20100419212950.GB8811@nowhere>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com> <4BCCBF6D.3030105@am.sony.com> <1271709846.10448.29.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271709846.10448.29.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 04:44:06PM -0400, Steven Rostedt wrote:
> I thought about a separate file, but I like the idea of having control
> over them. We could add a "trigger" file too, but I'm not sure if that
> would be any clearer.
> 
> If we add a trigger file, then the filter can be separate, and we just
> trigger the trigger if the filter passes.
> 
> This may be better, because then the triggers do not mess with the
> filtering code, and I can add it without modification to Tom's code.
> 
> -- Steve
> 
> 


The problem with having triggers defined in the filter file is that
you couldn't set a normal filter plus a trigger.

That said a filter itself could be a trigger.

if (cond) filter

This is going to break some ABI though.

In fact having one file per trigger type is going to make the
things much easier if you don't want to encumber with syntax parsing,
and just reuse the filtering code as is with very few modification.
This is going to be also easier for the users as they don't have to
remember the syntax or the available triggers.

Say you are in an event directory:

$ ls triggers/

filter
tracing_off
tracing_on
dump_trace

$ echo "(a == 1 && b == 2)" > tracing_off

So in the above example, you just reuse the filtering code,
no need to parse an if or a command.
The filter becomes a command. I've listed it in the triggers
directory but this just to express the fact it can be treated
like whatever trigger command, this is just an implementation
POV. In fact we can just keep it in the event directory.


