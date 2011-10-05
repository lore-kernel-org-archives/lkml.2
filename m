Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab1JEHCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:02:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab1JEHCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:02:18 -0400
Date: Tue, 4 Oct 2011 23:53:09 -0700
From: Greg KH <gregkh@suse.de>
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: quilt-dev@nongnu.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Quilt-dev] [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
Message-ID: <20111005065309.GA6676@suse.de>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
 <20111004180237.GA15087@suse.de>
 <1317752148.18063.16.camel@gandalf.stny.rr.com>
 <20111004182615.GA16224@suse.de>
 <1317753468.18063.19.camel@gandalf.stny.rr.com>
 <1317779312.1662.37.camel@schurl.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317779312.1662.37.camel@schurl.linbit>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 03:48:26AM +0200, Andreas Gruenbacher wrote:
> On Tue, 2011-10-04 at 14:37 -0400, Steven Rostedt wrote:
> > On Tue, 2011-10-04 at 11:26 -0700, Greg KH wrote:
> > 
> > > > What are git's "split" subject: lines?
> > > 
> > > Do the following:
> > >  $ git show --pretty=email 21d17dd2a377ba894f26989915eb3c6e427a3656
> > > 
> > > and look at how the Subject line is formatted:
> > > 	Subject: [PATCH] ASoC: Fix setting update bits for WM8753_LADC and
> > > 	 WM8753_RADC
> > > 
> > > Which is legal for email subject lines.  But quilt can't handle this and
> > > ends up thinking the data after the Subject: line is part of the patch
> > > text body and messes stuff up when doing 'quilt mail' later.
> 
> Aah, all this email parsing code is so ugly.  I think it works now
> though.

"now" meaning which version of quilt?  I still see this on 0.48 if that
matters.

> > > Oh, then there's the issue of quilt not handling ',' in a Signed-off-by
> > > line as a valid email address name, but I've been living with that one
> > > for years...
> 
> That's not even valid in email addresses.  The proper way would be to
> double-quote the "display name" which probably contains the comma, but
> then quilt's edmail script still won't understand it.  Is this a real
> problem?

Yes, quoting is the correct thing to do, but that does not usually
happen in "Signed-off-by:" lines in kernel patches.

Actually, I think this is even a problem when the name is quoted
properly, I've had to fix that up in patches by hand.

And yes, this is a problem, I run into at least 1-2 patches per stable
kernel release with this issue.  I looked into fixing it and somehow the
email parsing logic was wierd and I couldn't figure out how to resolve
it.

thanks,

greg k-h
