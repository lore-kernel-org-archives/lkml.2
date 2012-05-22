Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab2EVIxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:53:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:59565 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755829Ab2EVIxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:53:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/r9OJHQbbrqHyN/e5mo6pSqLhMcZAqzD03T6qw+F
	MO+S3lS4DPfPwF
Message-ID: <1337676822.5446.3.camel@marge.simpson.net>
Subject: Re: [PATCH 0/2] RFC: readd fair sleepers for server systems
From: Mike Galbraith <efault@gmx.de>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 22 May 2012 10:53:42 +0200
In-Reply-To: <4FBB3C35.1040104@linux.vnet.ibm.com>
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
	 <1337624236.5476.16.camel@marge.simpson.net>
	 <4FBB3C35.1040104@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 09:11 +0200, Christian Ehrhardt wrote: 
> 
> On 05/21/2012 08:17 PM, Mike Galbraith wrote:
> > On Mon, 2012-05-21 at 17:45 +0200, Martin Schwidefsky wrote:
> >> our performance team found a performance degradation with a recent
> >> distribution update in regard to fair sleepers (or the lack of fair
> >> sleepers). On s390 we used to run with fair sleepers disabled.
> >>
> >> We see the performance degradation with our network benchmark and fair
> >> sleepers enabled, the largest hit is on virtual connections:
> >
> > I can see you wanting the feature back.  You guys apparently do not
> > generally run mixed loads on your boxen, else you wouldn't want to turn
> > the scheduler into a tick granularity scheduler, but why compile time?
> > If the fast path branch isn't important, and given it only became
> > important while I was trying to scrape a few cycles together, why not
> > just restore the feature as it used to exist under the pretext that you
> > need it, and others may as well, so we eat the branch in the interest of
> > general flexibility, and call removal a booboo?
> >
> > -Mike
> >
> 
> If "eating the branches" is fine for everyone s390 can surely live with 
> it. The intention to make it configurable, was to allow systems that 
> really never want it, to be still able to avoid the branch.
> 
> By that everyone can configure it the way they want it and we avoid 
> another modification of the same code over and over again.

Ok.  Features have become cheaper, but we can still use every cycle we
can get our grubby mitts on.

-Mike


