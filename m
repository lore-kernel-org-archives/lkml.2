Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab2E3Sqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:46:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48346 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab2E3Sqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:46:44 -0400
Date: Wed, 30 May 2012 20:46:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org, hughd@google.com,
        sivanich@sgi.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        andi@firstfloor.org
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
Message-ID: <20120530184638.GU27374@one.firstfloor.org>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com> <alpine.DEB.2.00.1205301328550.31768@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205301328550.31768@router.home>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 01:34:21PM -0500, Christoph Lameter wrote:
> On Wed, 30 May 2012, Linus Torvalds wrote:
> 
> > On Wed, May 30, 2012 at 2:02 AM,  <kosaki.motohiro@gmail.com> wrote:
> > >
> > > So, I think we should reconsider about shared mempolicy completely.
> >
> > Quite frankly, I'd prefer that approach. The code is subtle and
> > horribly bug-fraught, and I absolutely detest the way it looks too.
> > Reading your patches was actually somewhat painful.
> 
> It is so bad mostly because the integration of shared memory policies with
> cpusets is not really working. Using either in isolation is ok especially
> shared mempolicies do not play well with cpusets.

Yes the cpusets did some horrible things.

I always regretted that cpusets were no done with custom node lists.
That would have been much cleaner and also likely faster than what we have.

> > If we could just remove the support for it entirely, that would be
> > *much* preferable to continue working with this code.
> 
> Well shm support needs memory policies to spread data across nodes etc.
> AFAICT support was put in due to requirements to support large database
> vendors (oracle). Andi?

Yes we need shared policy for the big databases.

Maybe we could stop supporting cpusets with that though. Not sure they
really use that.

> Its not going to be easy to remove.

Shared policies? I don't think you can remove them.
cpusets+shared policy? maybe, but still will be hard. 

-Andi

> 

-- 
ak@linux.intel.com -- Speaking for myself only.
