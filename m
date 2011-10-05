Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935390Ab1JEUNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:13:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935233Ab1JEUNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:13:09 -0400
Date: Wed, 5 Oct 2011 13:12:44 -0700
From: Greg KH <gregkh@suse.de>
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: quilt-dev@nongnu.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Quilt-dev] [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
Message-ID: <20111005201244.GA13027@suse.de>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
 <20111004180237.GA15087@suse.de>
 <1317752148.18063.16.camel@gandalf.stny.rr.com>
 <20111004182615.GA16224@suse.de>
 <1317753468.18063.19.camel@gandalf.stny.rr.com>
 <1317779312.1662.37.camel@schurl.linbit>
 <20111005065309.GA6676@suse.de>
 <1317813674.1623.10.camel@schurl.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317813674.1623.10.camel@schurl.linbit>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 01:21:07PM +0200, Andreas Gruenbacher wrote:
> On Wed, 2011-10-05 at 10:23 +0200, Andreas Gruenbacher wrote:
> > On Tue, 2011-10-04 at 23:53 -0700, Greg KH wrote:
> > > Yes, quoting is the correct thing to do, but that does not usually
> > > happen in "Signed-off-by:" lines in kernel patches.
> > > 
> > > Actually, I think this is even a problem when the name is quoted
> > > properly, I've had to fix that up in patches by hand.
> > 
> > Yes, proper quoting currently isn't enough.
> >
> > > And yes, this is a problem, I run into at least 1-2 patches per stable
> > > kernel release with this issue.  I looked into fixing it and somehow the
> > > email parsing logic was wierd and I couldn't figure out how to resolve
> > > it.
> > 
> > Okay, I'll have another look ...
> 
> I've tried to address this as follows now:
> 
> commit f3e7822028616014f933b99d05f42fc028f8d12c
> Author: Andreas Gruenbacher <agruen@linbit.com>
> Date:   Wed Oct 5 12:57:48 2011 +0200
> 
>     quilt mail: Allow commas in Signed-off-by and Acked-by lines
>     
>     The standard quilt_mail_patch_filter() in quilt mail tries to extract email
>     addresses from Signed-off-by and Acked-by lines.  It adds Cc headers with those
>     addresses.
>     
>     Signed-off-by and Acked-by lines sometimes contain commas as part of the
>     address.  When put in recipient headers (To, Cc, Bcc), the commas are
>     interpreted as separators, which breaks things.
>     
>     Try to recognize this case and add the appropriate quotes.  For example, the
>     email address in ``Signed-off-by: Gruenbacher, Andreas <agruen@linbit.com>'' is
>     now extracted as ``"Gruenbacher, Andreas" <agruen@linbit.com>''.
>     
>     Note that quilt_mail_patch_filter() can be overridden in .quiltrc; you may need
>     to update your .quiltrc.
> 
> commit c6750845136ff21eb13bc99ec7a6e1689100a13a
> Author: Andreas Gruenbacher <agruen@linbit.com>
> Date:   Wed Oct 5 12:08:05 2011 +0200
> 
>     quilt mail: Support double quoted special characters in email adresses
>     
>     Addresses like "Gruenbacher, Andreas" <agruen@linbit.com> will work now.
> 
> 
> Please give it a shot.

Thanks for doing this.  I can't seem to find the git tree for quilt at
the moment, any pointers to where it is?

greg k-h
