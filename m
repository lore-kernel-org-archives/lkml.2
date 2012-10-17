Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab2JQVqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 17:46:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33768 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270Ab2JQVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 17:46:08 -0400
X-Sasl-enc: 3YwEl60aekPkjjUdgW4PUCGRX903O+7WwnSndv1QDa6n 1350510367
Date: Wed, 17 Oct 2012 14:46:06 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Romain Francoise <romain@orebokech.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 2.6.32.60
Message-ID: <20121017214606.GD7083@kroah.com>
References: <20121009094453.GA4289@1wt.eu>
 <87y5jeqv6b.fsf@silenus.orebokech.com>
 <20121011062916.GG8938@1wt.eu>
 <20121011105804.GB28546@kroah.com>
 <20121011113106.GR8938@1wt.eu>
 <50775210.4060007@zytor.com>
 <20121012063848.GD12041@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012063848.GD12041@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 08:38:48AM +0200, Willy Tarreau wrote:
> On Fri, Oct 12, 2012 at 07:11:12AM +0800, H. Peter Anvin wrote:
> > On 10/11/2012 07:31 PM, Willy Tarreau wrote:
> > > On Thu, Oct 11, 2012 at 07:58:04PM +0900, Greg KH wrote:
> > >> On Thu, Oct 11, 2012 at 08:29:16AM +0200, Willy Tarreau wrote:
> > >>> If you think these patches constitute a regression, I can revert them.
> > >>> However I'd like convincing arguments since they're here to help address
> > >>> a real issue.
> > >>
> > >> If I missed these when doing the random number generation backport for
> > >> 3.0, and I should add them there as well, please let me know.
> > > 
> > > At least I think they should not be in 2.6.32 without being in 3.0.
> > > Probably that Peter's opinion will help us decide whether they should
> > > go into 3.0 or 2.6.32 should revert them.
> > > 
> > 
> > I would strongly argue for at least one of the RDRAND-enabling versions
> > being in all supported kernels; the second (with Ted Ts'o's changes) is
> > better, but touches a *lot* of subsystems; the plain one is
> > self-contained but only helps RDRAND-enabled hardware.
> > 
> > Without these patches the random subsystem has a critical security flaw,
> > which puts it into the scope for stable.
> 
> That's clearly what I understood, thanks Peter for confirming ! So I won't
> revert the patches unless a regression is reported in which case we'll
> prefer to fix it.
> 
> Greg, I think it would be better to get them into 3.0 too. The ones I used
> were (prefixed with 'X' if they are already in 3.0) :
>    24da9c26 x86, cpu: Add CPU flags for F16C and RDRND

This showed up in 2.6.36

>    7ccafc5f x86, cpufeature: Update CPU feature RDRND to RDRAND

This showed up in 3.0

>  X 63d77173 random: Add support for architectural random hooks
>  X bd29e568 fix typo/thinko in get_random_bytes()
>    628c6246 x86, random: Architectural inlines to get random integers with RDRAND
>    49d859d7 x86, random: Verify RDRAND functionality and allow it to be disabled

I've now queued up these two as they were relevant here.

thanks,

greg k-h
