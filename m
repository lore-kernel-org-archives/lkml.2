Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1FOCsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:48:46 -0400
Received: from support.opsdc.com ([65.254.219.9]:47079 "EHLO support.opsdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1FOCsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:48:45 -0400
Subject: Re: Panic on OOM
From: Chris Fowler <cfowler@outpostsentinel.com>
Reply-To: cfowler@opsdc.com
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1106141908100.7025@chino.kir.corp.google.com>
References: <1308058276.2074.295.camel@compaq-desktop>
	 <alpine.DEB.2.00.1106141656220.31202@chino.kir.corp.google.com>
	 <1308103443.2074.357.camel@compaq-desktop>
	 <alpine.DEB.2.00.1106141908100.7025@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 22:48:39 -0400
Message-ID: <1308106119.2074.363.camel@compaq-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 19:32 -0700, David Rientjes wrote:
> On Tue, 14 Jun 2011, Chris Fowler wrote:
> 
> > > Using /proc/sys/vm/panic_on_oom also won't panic the machine if you
> > > happen to use a cpuset or mempolicy.  You'll want to write '2' instead
> > > if you want to panic in all possible oom conditions.
> > > 
> > > 
> > 
> > 2 did it.  Thank you.
> > 
> > perl -e 'my @mem = (); while(1) { push @mem, "XXXXXXXXXXXXXXXX"; }'
> > 
> > I lost connection and it came back after about 30s.  Reboot worked.
> > 
> 
> That wasn't meant as a fix for the problem but rather just a suggestion 
> based on how you're using the device.
> 
> It's just a coincidence that it worked that time, because 
> /proc/sys/vm/panic_on_oom == 2 is the exact same as 
> /proc/sys/vm/panic_on_oom == 1 with the .config you posted (since you 
> don't have CONFIG_NUMA, constrained_alloc() always returns CONSTRAINT_NONE 
> in the oom killer).

Yea you're right.  I just did it again and it does not reboot.  It goes
in this state where it no longer responds.  The keyboard is not
responsive the screen blank no longer works, etc.  

Right now I'm just waiting for it to panic.


