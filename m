Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab1CJPvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:51:22 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53643 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1CJPvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:51:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=OI29xAQ8wJEJkSqGsvFHvg3UgvNtNz42P0v+m/E1yKJL5v7Jhv6AOf3Z0RhxgxPoNL
         dof0IPNHFykB0ENG6cvWsZOFVl4cI9UMaHSm44zeb/cWOz+LLgH3fZpNO6S7L5PeKr2B
         Fk5a5Ec6DNjdJFND6zI37mCCMpu25PEPGDWmA=
Date: Thu, 10 Mar 2011 12:51:09 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf script: move printing of 'common' data from
 print_event and rename
Message-ID: <20110310155109.GB23555@ghostprotocols.net>
References: <1299734608-5223-1-git-send-email-daahern@cisco.com>
 <1299734608-5223-4-git-send-email-daahern@cisco.com>
 <20110310152053.GB12521@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110310152053.GB12521@home.goodmis.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 10, 2011 at 10:20:53AM -0500, Steven Rostedt escreveu:
> On Wed, Mar 09, 2011 at 10:23:25PM -0700, David Ahern wrote:
> > This change does impact output: latency data is trace specific and is now
> > printed after the common data - comm, tid, cpu, time and event name.

> > Signed-off-by: David Ahern <daahern@cisco.com>

> >  tools/perf/builtin-script.c         |   38 ++++++++++++++++++++++-----
> >  tools/perf/util/trace-event-parse.c |   49 +++++++---------------------------

> I was hoping after the next merge window to start making a common library
> for parsing events. This way things like powertop and timechart or
> anything that uses the perf interface does not need to write its own
> parsing of events, or expect the event formats to be hardcoded.
> 
> The trace-event-parse.c was taking from trace-cmd's parse-events.c code
> and hopefully the two can merge again. The parse-events.c code in
> trace-cmd has gone through several iterations that has made it much more
> robust and flexible. I purposely kept it as a separate libarary not
> dependent on trace-cmd so that it could be used by other utilities like
> perf.

David is kinda new to this perf/ftrace/trace-cmd/etc soap opera, and he
has been patient to go thru the motions with Peter, Thomas, Frédéric and
me, going from doing what he wants in 'perf report' to 'perf script',
etc.

We're almost to the point where his feature is implemented in a
way Frédéric, the one most actively reviewing his work, is satisfied,
right Frédéric?

I think the merge with the libraries you mention is something that is
not a precondition to merging David's work.

And his work is at least moving things in the trace parts of tools/,
that was so far dormant.

- Arnaldo
