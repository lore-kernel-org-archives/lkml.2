Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab1EMStR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:49:17 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44636 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685Ab1EMStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:49:15 -0400
Subject: Re: Possible sandybridge livelock issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux.com>, x86@kernel.org,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
In-Reply-To: <m21v02zch9.fsf@firstfloor.org>
References: <1305303156.2611.51.camel@mulgrave.site>
	 <m262pezhfe.fsf@firstfloor.org>
	 <alpine.DEB.2.00.1105131207020.24193@router.home>
	 <m21v02zch9.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 13:49:11 -0500
Message-ID: <1305312552.2611.66.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 11:23 -0700, Andi Kleen wrote:
> Christoph Lameter <cl@linux.com> writes:
> 
> > On Fri, 13 May 2011, Andi Kleen wrote:
> >
> >> Turbo mode just makes the CPU faster, but it should not change
> >> the scheduler decisions.
> >
> > I also have similar issues with Sandybridge on Ubuntu 11.04 and kernels
> > 2.6.38 as well as 2.6.39 (standard ubuntu kernel configs).
> 
> It still doesn't make a lot of sense to blame the CPU for this.
> This is just not the level how CPU problems would likely appear.
> 
> Can you figure out better what the kswapd is doing?

We have ... it was the thread in the first email.  We don't need a fix
for the kswapd issue, what we're warning about is a potential
sandybridge problem.

The facts are that only sandybridge systems livelocked in the kswapd
problem ... no other systems could reproduce it, although they did see
heavy CPU time accumulate to kswapd.  And this is with a gang of mm
people trying to reproduce the problem on non-sandybridge systems.

On the sandybridge systems that livelocked, it was sometimes possible to
release the lock by pushing kswapd off the cpu it was hogging.

If you think the theory about why this happend to be wrong, fine ...
come up with another one.  The facts are as above and only sandybridge
systems seem to be affected.

James


