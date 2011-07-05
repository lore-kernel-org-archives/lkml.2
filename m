Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1GENtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:49:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50714 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1GENtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:49:31 -0400
Date: Tue, 5 Jul 2011 15:49:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mundt <lethal@linux-sh.org>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/6] hw_breakpoints: Migrate breakpoint conditional build
 under new config
Message-ID: <20110705134920.GF5551@somewhere>
References: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
 <1306273947-8410-3-git-send-email-fweisbec@gmail.com>
 <20110704132746.GA2963@in.ibm.com>
 <20110704132912.GB5551@somewhere>
 <20110704174416.GA2166@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704174416.GA2166@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 11:14:16PM +0530, K.Prasad wrote:
> On Mon, Jul 04, 2011 at 03:29:14PM +0200, Frederic Weisbecker wrote:
> > On Mon, Jul 04, 2011 at 06:57:46PM +0530, K.Prasad wrote:
> > > On Tue, May 24, 2011 at 11:52:23PM +0200, Frederic Weisbecker wrote:
> > > > Migrate conditional hw_breakpoint code compilation under
> > > > the new config to prepare for letting the user chose whether
> > > > or not to build this feature
> > > > 
> > > 
> > > Making the hardware breakpoint patches modular has always been a goal.
> > > I've looked at the PowerPC parts of the code and they look harmless.
> > > 
> > > Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > 
> > Great!
> > 
> > I'll push that soon, thanks guys for your acks!
> 
> Meanwhile, I was testing hardware breakpoints through perf and found
> that monitoring a given address fails when using 'perf record' (returns
> -ENOSPC) while 'perf stat' and watchpoint through gdb works fine (see
> logs below).
> 
> Has this behaviour been reported for other perf counters?

Nope I haven't anything like that. What I reported privately to you a
few ago was actually due to a mistake of mine. Otherwise I haven't seen
other problems.

-ENOSPC is likely related to the breakpoint slot reservation, in kernel/events/hw_breakpoint.c
