Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0DYHQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 03:16:14 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49834 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751038Ab0DYHQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 03:16:12 -0400
Date: Sun, 25 Apr 2010 09:16:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Rik van Riel <riel@redhat.com>, John Stoffel <john@stoffel.org>,
       Hedi Berriche <hedi@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
Message-ID: <20100425071606.GB1275@ucw.cz>
References: <20100421165934.GN16427@zorg.emea.sgi.com>
 <4BCF336B.1050706@redhat.com>
 <19407.20109.308816.104856@stoffel.org>
 <20100421193350.GU16427@zorg.emea.sgi.com>
 <19407.23456.469074.256306@stoffel.org>
 <20100421222414.GA26241@suse.de>
 <4BCF80F2.2010906@redhat.com>
 <20100421232200.GA22877@suse.de>
 <20100422102852.72837494@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Distros don't want to take a patch that adds a new boot param that is
> > > not accepted upstream, otherwise they will be stuck forward porting it
> > > from now until, well, forever :)
> > 
> > So for an obscure IA64 specific problem you want the upstream kernel to
> > port it forward forever instead ?
> 
> Ehh. Nobody does ia64 any more. It's dead, Jim.
> 
> This is x86. SGI finally long ago gave up on the Intel/HP clusterf*ck.
> 
> Which I'm not entirely sure makes the case for the kernel parameter much 
> stronger, though. I wonder if it's not more appropriate to just have a 
> total hack saying
> 
> 	if (max_pids < N * max_cpus) {
> 		printk("We have %d CPUs, increasing max_pids to %d\n");
> 		max_pids = N*max_cpus;
> 	}
> 
> where "N" is just some random fudge-factor. It's reasonable to expect a 
> certain minimum number of processes per CPU, after all.

Issue with max_pids is that it can break userspace, right?

At that point it seems saner to require a parameter --- just adding
cpus to the system should not do it... 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
