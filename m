Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2ENKsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:48:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54268 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2ENKse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:48:34 -0400
Date: Mon, 14 May 2012 12:48:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: Commit cb83b62 fails to boot with a divide by zero error.
Message-ID: <20120514104829.GA25923@gmail.com>
References: <20120511133938.GG3751@sgi.com>
 <1336746790.1017.17.camel@twins>
 <20120511150533.GH3751@sgi.com>
 <1336750573.1017.25.camel@twins>
 <20120511155549.GI3751@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511155549.GI3751@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> On Fri, May 11, 2012 at 05:36:13PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-05-11 at 10:05 -0500, Robin Holt wrote:
> > > On Fri, May 11, 2012 at 04:33:10PM +0200, Peter Zijlstra wrote:
> > > > On Fri, 2012-05-11 at 08:39 -0500, Robin Holt wrote:
> > > > 
> > > > > We found that reverting the commit:
> > > > > cb83b62 (x86/sched/core) sched/numa: Rewrite the CONFIG_NUMA sched domain support
> > > > > 
> > > > > also got things working.
> > > > 
> > > > there's a particularly stupid bug in that code
> > > 
> > > Even with that applied, I still get the divide by zero.
> > 
> > Humm.. what kind of machine is this? And how far along does it get in
> > booting? ->power isn't supposed to get to 0.
> 
> It is a four blade (8 socket 80 core 160 hyper-thread machine) 
> with 40 GB of RAM.
> 
> Looking at the earlier kernel messages, I am wondering if I 
> don't have a BIOS that is giving me crud.  I have messages 
> about hyperthreads being on different nodes.  That had not 
> been happening in the past.  I don't have access to the 
> machine now, but the BIOS string that had printed out is from 
> a developer's debug version.
> 
> When I get access to the machine again (likely not until 
> Monday), I will flash a release BIOS and retest.  Until then, 
> please feel free to ignore me.

Please don't re-flash the BIOS! We want to fix this bug - the 
kernel should never crash on whatever topology data the BIOS 
passes.

We can sanitize it or ignore it, but crashing is not an option. 
So lets figure this out, ok?

Thanks,

	Ingo
