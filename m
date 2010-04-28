Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0D1RpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:45:15 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53473 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756071Ab0D1RpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:45:10 -0400
Date: Wed, 28 Apr 2010 13:45:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <tj@kernel.org>, Jiri Benc <jbenc@suse.cz>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [171/197] module: fix __module_ref_addr()
Message-ID: <20100428174507.GA4149@Krystal>
References: <20100422191857.GA13268@kroah.com> <20100422190922.702027944@kvm.kroah.org> <20100428165201.3d7d6b4a@griffin.suse.cz> <20100428162056.GA2846@Krystal> <20100428185550.4406319c@logostar.upir.cz> <4BD86F3D.7040907@kernel.org> <20100428172944.GA14660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428172944.GA14660@kroah.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:43:09 up 95 days, 20:20,  6 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Wed, Apr 28, 2010 at 07:24:13PM +0200, Tejun Heo wrote:
> > On 04/28/2010 06:55 PM, Jiri Benc wrote:
> > > On Wed, 28 Apr 2010 12:20:56 -0400, Mathieu Desnoyers wrote:
> > >> Can you try reverting commit c8d52465f95c4187871f8e65666c07806ca06d41 and see if
> > >> it helps ?
> > > 
> > > It doesn't. The produced code is identical.
> > > 
> > >> If you have other compiler versions handy, that would also be helpful to see if
> > >> the problem is specific to the gcc version you are using.
> > > 
> > > Tried 4.5.0, the same problem (at least looking at the produced assembler
> > > code, I haven't booted the kernel, but it looks very similar to 4.3.3).
> > 
> > I wrote on the bugzilla but this is not a compiler bug but the -stable
> > patch shouldn't have been applied only to 2.6.33.  Not 2.6.32.  This
> > is because till 2.6.32, ia64 hadn't been converted to dynamic percpu
> > allocator, so its static and dynamic percpu areas were separate and
> > the per_cpu_ptr() wouldn't do the offsetting the module code expects
> > there.  So, please revert the patch from 2.6.32.
> 
> Ah crap, I missed that.  I'll go revert it from .32 now, sorry about
> that.
> 
> greg k-h

My bad, I indicated that it should be applied to 2.6.29.x through 2.6.33.x in
the changelog.

Sorry,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
