Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1KATAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:00:06 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:60750 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1KATAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:00:04 -0400
Subject: Re: [PATCH v5 33/36] Hexagon: Add configuration and makefiles for
 the Hexagon architecture.
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org
In-Reply-To: <20111101172709.GA3035@codeaurora.org>
References: <093448$3uejv7@wolverine01.qualcomm.com>
	 <1320139846.14409.129.camel@x61.thuisdomein>
	 <20111101172709.GA3035@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 19:59:52 +0100
Message-ID: <1320173992.14409.193.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 12:27 -0500, Richard Kuo wrote:
> On Tue, Nov 01, 2011 at 10:30:46AM +0100, Paul Bolle wrote:
> > Is GENERIC_PENDING_IRQ also a pending project?
> 
> Yes.

So, you'll move it up a line?
 
> > > +#config ZONE_DMA
> > > +#	bool
> > > +#	default y
> > 
> > Why is this added commented out?
> 
> We were using it before, but not anymore.

So, please drop it.

> > > +config STACKTRACE_SUPPORT
> > > +	def_bool y
> > > +	select STACKTRACE
> > 
> > Some grepping suggests that the tracing infrastructure will "select
> > STACKTRACE" if the architecture sets STACKTRACE_SUPPORT (tile apparently
> > also gets this wrong). Have I grepped this correctly?
> 
> Only if DEBUG_KMEMLEAK is selected apparently (?)

But "config TRACING" (in kernel/trace/Kconfig) also selects it if
STACKTRACE_SUPPORT is set. It seems GENERIC_TRACER is the hidden magic
here. GENERIC_TRACER is selected by the various tracer options - see
kernel/trace/Kconfig again, I'm unfamiliar with this stuff - and will
itself select TRACING. So if an arch has STACKTRACE_SUPPORT set it
doesn't have to select STACKTRACE itself. (Note that - except for tile -
no other arch selects STACKTRACE.) 

But hopefully someone who doesn't have to grep the Kconfig files to
understand this, can tell us for sure.

> We felt it was better to remove the platform code for this submission
> as it was not exactly clean and did not use the devtree code.  That's
> why it's commented out of the Makefiles.

If you really feel you need to add it, but commented out, perhaps a
comment can be added to keep people like me from submitting patches to
remove it.


Paul Bolle

