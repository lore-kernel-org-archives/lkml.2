Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2ERPuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:50:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:59574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883Ab2ERPuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:50:06 -0400
Message-ID: <1337356192.573.75.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 17:49:52 +0200
In-Reply-To: <alpine.DEB.2.00.1205181047030.21093@router.home>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <4FB66756.2060302@redhat.com> <1337355341.573.68.camel@twins>
	 <1337355610.573.70.camel@twins>
	 <alpine.DEB.2.00.1205181047030.21093@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 10:47 -0500, Christoph Lameter wrote:
> On Fri, 18 May 2012, Peter Zijlstra wrote:
> 
> > On Fri, 2012-05-18 at 17:35 +0200, Peter Zijlstra wrote:
> > > I've also said many times over that I absolutely detest all the async
> > > stuff because it messes up accounting. And until someone comes up with a
> > > sane means of sorting that I'll stick to migrate-on-fault.
> >
> > The other nice advantage of migrate-on-fault is that you don't have to
> > play lifetime games with vmas. This much simplifies that aspect.
> 
> The problem with migrate on fault in the past has been that there was no
> consistent benefit from the overhead added to the system. Useless page
> migration is a bit expensive.

I'm not sure I follow.. having the page local is a win, presuming you
can limit the migration rate to something low in relation to the cost of
remote accesses.

How does it matter how you migrate?
