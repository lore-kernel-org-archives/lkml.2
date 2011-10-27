Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1J0GAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 02:00:37 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48610 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab1J0GAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 02:00:35 -0400
X-Sasl-enc: tMGPjsqal5Nv1GG9lCyuSG8Kpc1qaIUhvSw4mn2Loxsc 1319695234
Date: Thu, 27 Oct 2011 07:49:20 +0200
From: Greg KH <greg@kroah.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Bowler <nbowler@elliptictech.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
Message-ID: <20111027054920.GA1388@kroah.com>
References: <4EA57CBF.2050901@xenotime.net>
 <87k47tpvvm.fsf@rustcorp.com.au>
 <20111025153855.GA24779@elliptictech.com>
 <1319558749.11727.6.camel@deadeye>
 <20111025165142.GA25354@elliptictech.com>
 <20111025200455.GA6376@kroah.com>
 <20111025201723.GA25063@redhat.com>
 <20111025205410.GA7479@kroah.com>
 <20111026130834.GA6387@elliptictech.com>
 <874nyvnsqe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nyvnsqe.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 11:41:37AM +1030, Rusty Russell wrote:
> On Wed, 26 Oct 2011 09:08:34 -0400, Nick Bowler <nbowler@elliptictech.com> wrote:
> > On 2011-10-25 22:54 +0200, Greg KH wrote:
> > > On Tue, Oct 25, 2011 at 04:17:24PM -0400, Dave Jones wrote:
> > > > On Tue, Oct 25, 2011 at 10:04:55PM +0200, Greg Kroah-Hartman wrote:
> > > >  > On Tue, Oct 25, 2011 at 12:51:42PM -0400, Nick Bowler wrote:
> > > >  > > This is not the case: lockdep works fine with staging modules.
> > > >  > 
> > > >  > Yes, that was fixed a few kernel versions ago.
> > > >  > 
> > > >  > Now you might want to update that fix for the TAINT_OOT_MODULE flag as
> > > >  > well, if you feel it is needed.
> > > > 
> > > > I'm assuming you mean this patch ?
> > > > 
> > > > commit 7816c45bf13255157c00fb8aca86cb64d825e878
> > > > Author: Roland Vossen <rvossen@broadcom.com>
> > > > Date:   Thu Apr 7 11:20:58 2011 +0200
> > > > 
> > > >     modules: Enabled dynamic debugging for staging modules
> > > 
> > > Hm, this is the patch I was thinking about yes.  But as you point out:
> > [...]
> > > Perhaps the lockdep thing is totally different.  I don't know about that
> > > check.
> > 
> > Lockdep is disabled (for the whole system) by add_taint itself.  The
> > relevant commit that fixes TAINT_CRAP appears to be this one (circa
> > 2.6.30):
> > 
> >   commit 574bbe782057fdf0490dc7dec906a2dc26363e20
> >   Author: Frederic Weisbecker <fweisbec@gmail.com>
> >   Date:   Sat Apr 11 03:17:18 2009 +0200
> >   
> >       lockdep: continue lock debugging despite some taints
> > 
> > I didn't know about the dynamic debug problem.  Is there more breakage
> > that we haven't found yet?  Remind me why we're trying to cripple out
> > of tree module users?
> 
> Gah, people are overloading taint.
> 
> It doesn't mean "don't do stuff", it means "note the taint when
> something goes wrong".

I agree, we shouldn't be changing logic in the kernel due to tainting,
so removing any such checks would be a good idea.

thanks,

greg k-h
