Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0ELWPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:15:40 -0400
Received: from kroah.org ([198.145.64.141]:34949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab0ELWPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:15:38 -0400
Date: Wed, 12 May 2010 15:14:34 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Kosina <jkosina@suse.cz>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, stable@kernel.org,
       Jiri Benc <jbenc@suse.cz>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Eric Dumazet <dada1@cosmosbay.com>,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [171/197] module: fix __module_ref_addr()
Message-ID: <20100512221434.GA2786@kroah.com>
References: <20100422191857.GA13268@kroah.com>
 <20100422190922.702027944@kvm.kroah.org>
 <20100428165201.3d7d6b4a@griffin.suse.cz>
 <20100428162056.GA2846@Krystal>
 <20100428185550.4406319c@logostar.upir.cz>
 <4BD86F3D.7040907@kernel.org>
 <20100428172944.GA14660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428172944.GA14660@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 10:29:44AM -0700, Greg KH wrote:
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

And of course, I forgot to do that before releasing the next .32 kernel.
It will be in the one after this one.  bah.

greg k-h
