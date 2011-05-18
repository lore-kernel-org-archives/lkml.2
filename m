Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1ERXkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:40:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab1ERXkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qpXTomKHTOxKTysD4yEnHxQbZEneJi3HrQS0k6rFBnC7MvuSPV8k9hCkYVXCWK/gdc
         NWJ1IUJA2WBrBFNQTDfUiQYCQiN7jZ3TQ5TjVqcrBJrPa7Wsop8PdtUc3J9SW+4DK+1z
         HDEKdX7oaUUEFbkZJe+caq8zMBRrUPdt3QVjM=
Date: Thu, 19 May 2011 01:40:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing: Register static events output early
Message-ID: <20110518234015.GB1723@nowhere>
References: <1305761368-5488-1-git-send-email-fweisbec@gmail.com>
 <1305761839.11267.23.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305761839.11267.23.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 07:37:19PM -0400, Steven Rostedt wrote:
> On Thu, 2011-05-19 at 01:29 +0200, Frederic Weisbecker wrote:
> 
> > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > index cf535cc..ad92d9c 100644
> > --- a/kernel/trace/trace_output.c
> > +++ b/kernel/trace/trace_output.c
> > @@ -1278,4 +1278,4 @@ __init static int init_events(void)
> >  
> >  	return 0;
> >  }
> > -device_initcall(init_events);
> > +early_initcall(init_events);
> 
> Hmm, careful here. The ring buffers are also allocated at early_init().
> 
> But you may be OK, as things like trace_printk() don't do anything if
> "tracing_disabled" is set, and it's set on bootup and cleared after we
> allocate the buffers.

Yep, and the output callback only impact the read side anyway, once the trace
has been already pulled out of the buffer. I hope I'm not missing something in the
way...
