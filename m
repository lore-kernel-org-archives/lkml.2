Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0FJPfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:35:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0FJPfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:35:12 -0400
Date: Thu, 10 Jun 2010 11:34:33 -0400
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 01/13] jump label v9: notifier atomic call chain notrace
Message-ID: <20100610153432.GB3923@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
 <dd363dd9bd8e4d3f6330f4b573dae40b76bd6dd8.1276116186.git.jbaron@redhat.com>
 <20100609215810.GA12752@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609215810.GA12752@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 11:58:13PM +0200, Frederic Weisbecker wrote:
> On Wed, Jun 09, 2010 at 05:38:52PM -0400, Jason Baron wrote:
> > From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > 
> > In LTTng, being able to use the atomic notifier from cpu idle entry to
> > ensure the tracer flush the last events in the current subbuffer
> > requires the rcu read-side to be marked "notrace", otherwise it can end
> > up calling back into lockdep and the tracer.
> > 
> > Also apply to the the die notifier.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>
> > ---
> 
> 
> 
> I don't understand the purpose of this patch. The only notifier
> I see that is used by jmp label is the module notifier, and I
> don't see how it can do bad things if we don't use the notrace
> version.
> 

hmmm...yeah, this patch was introduced b/c of the use of the 'int3'
notifier when updating the kernel text. We got into a recursive loop
without it. However, since the current implementation is using
stop_machine() to do text updates, I don't think this patch is necessary
until we have the more optimal text updating mechanism in place. I'll
re-test without this patch.

thanks,

-Jason
