Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2I0VFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:05:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63790 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2I0VFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:05:10 -0400
Date: Thu, 27 Sep 2012 14:04:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Stable <stable@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: Re: [PATCH] pch_uart: Add eg20t_port lock field, avoid recursive
 spinlocks
Message-ID: <20120927210440.GB3468@kroah.com>
References: <422aa2054659680fb138d2153dcc852b2620b04d.1346889148.git.dvhart@linux.intel.com>
 <20120906001448.GA7278@kroah.com>
 <20120906001841.GA7433@kroah.com>
 <5047ED8C.1060005@linux.intel.com>
 <5047F045.5060103@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5047F045.5060103@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:37:25PM -0700, Darren Hart wrote:
> On 09/05/2012 05:25 PM, Darren Hart wrote:
> > 
> > 
> > On 09/05/2012 05:18 PM, Greg Kroah-Hartman wrote:
> >> On Wed, Sep 05, 2012 at 05:14:48PM -0700, Greg Kroah-Hartman wrote:
> >>> On Wed, Sep 05, 2012 at 05:04:07PM -0700, Darren Hart wrote:
> >>>> The following patch has been included in linux-next
> >>>> (fe89def79c48e2149abdd1e816523e69a9067191) but has not yet landed in mainline
> >>>> nor been queued for stable so far as I can determine. This patch addresses a
> >>>> deadlock in mainline and is a prerequisite for an additional fix required by the
> >>>> PREEMPT_RT kernel. Can we get this pulled into 3.4.11 please?
> >>>
> >>> 3.4.11?  It has to hit Linus's tree first.
> >>>
> >>>> Perhaps I am
> >>>> jumping the gun, but this patch was originally pulled on June 19, 2012.
> >>>
> >>> Remember, we missed a pull cycle for tty due to other problems, I
> >>> thought I picked all of the different pieces needed for 3.6, but I must
> >>> of missed this one.
> >>
> >> Nope, it made it, it is commit 2588aba002d14e938c2f56d299ecf3e7ce1302a5.
> > 
> > Doh, I pulled master and stable, but only checked stable. Sigh. My
> > apologies Greg.
> > 
> >>
> >> Now, do you want that patch in the -stable releases?  If so, how far
> >> back? :)
> > 
> > Yes, back to 3.0 would be ideal. It needs mangling for 3.2 and back
> > though. I will send patches for 3.4, 3.2 and possibly 3.0 following the
> > stable_kernel_rules.txt procedure.
> 
> On second thought, there are way too many changes to pch_uart that are
> required before this patch can really be applied prior to 3.4. I suspect
> these are not all appropriate for -stable. I'd be happy just getting
> this into 3.4.11. 2588aba002d14e938c2f56d299ecf3e7ce1302a5 cherry-picks
> cleanly to 3.4.

Now queued up for 3.4.y and 3.5.y, thanks.

greg k-h
