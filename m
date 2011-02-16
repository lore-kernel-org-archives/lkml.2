Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab1BPJZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:25:07 -0500
Received: from 1wt.eu ([62.212.114.60]:60587 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab1BPJZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:25:04 -0500
Date: Wed, 16 Feb 2011 10:24:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Kay Sievers <kay.sievers@vrfy.org>,
        Dan Carpenter <error27@gmail.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [114/115] sched: Remove  some dead code
Message-ID: <20110216092402.GC1558@1wt.eu>
References: <20110216014741.GA24678@kroah.com> <20110216014705.654816731@clark.kroah.org> <20110216073701.GS4384@bicker> <1297843004.8874.1.camel@marge.simson.net> <20110216083025.GB16529@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216083025.GB16529@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 09:30:25AM +0100, Ingo Molnar wrote:
> 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Wed, 2011-02-16 at 10:37 +0300, Dan Carpenter wrote:
> > > On Tue, Feb 15, 2011 at 05:46:20PM -0800, Greg KH wrote:
> > > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > > > 
> > > > ------------------
> > > > 
> > > > 
> > > > From: Dan Carpenter <error27@gmail.com>
> > > > 
> > > > commit 618765801ebc271fe0ba3eca99fcfd62a1f786e1 upstream.
> > > > 
> > > > This was left over from "7c9414385e sched: Remove USER_SCHED"
> > > > 
> > > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > 
> > > This is just a cleanup patch.  It doesn't really warrant backporting.
> > 
> > There's no reason to leave the dirt lying about though.
> 
> That's not the threshold for -stable backporting though.
> 
> A patch is eligible for -stable if and only if it's eligible for sending it to Linus 
> via tip:sched/urgent as well: i.e. important bugfix or fresh regression.
> 
> Now, a cleanup patch might still be eligible to be sent to Linus if for some reason 
> it's absolutely required for a fix - but in general we do not backport them.
> 
> The risk to -stable is obvious: instead of having a well-known .32 scheduler we have 
> this morphing code that no-one has really tested in that form.
> 
> So while i dont mind the series you sent, please lets be *much* more careful with 
> -stable backports in the future. Rule #1: if you ever have to ask yourself whether a 
> patch is -stable eligible it probably isnt.

Sometimes cleanup patches make the work easier for stable maintainers because
further patches apply without conflicts. It happened to me from time to time
in the past to merge such patches because I got bored of systematically having
to manually apply patches. But I agree with you that generally we should avoid
to merge such patches.

In my opinion the right question to ask oneself about the eligibility of a
patch is how you'd justify it to your end users. If you can justify it by
an improvement they can perceive (reliability, security, speed) then it may
be worth it. If it's just "that code was not used anymore", they'll start
to lose trust.

Regards,
Willy

