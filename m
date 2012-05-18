Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab2ERQAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:00:54 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:30055 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757778Ab2ERQAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:00:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QllVjOsVM1k_KMSAb.9uJvR2UfcbTV0Ld_Z8gHKkhFveb2I
 Jvc2CgaknTZk41KzOr_Dh2D98voN5u5jKu8HnrP74GFucCKJ_ZLdN9kVb49_
 _Gfzoum6e6ed7Cm2K4iYbe2lRyIy4Oq5ZcwbhEYcRDdPo3aMAK_YuPlWU4pl
 Z.7XhaA3XBliN_l5BNH25JNp__BDvC0GjT4gcAms1LlilH6CZwUXrasSKEjV
 mLVLbKwb8o8wm0cZmDcULHXiPmPSUNHFrL1IJPMsoaktQg9NnzKVScbEP2ny
 ve4iflB.Z7Ksb4LwMKnXt13_5kReLlyZXkMjDFW8QRLtqV8Q.sybF3C40HeC
 nalJze2YOc_yckeBm11v9Ktc8_d7M8QPB.qB_bzp1qanth6mxHBE1z8udhBh
 XTvqYr7IROV2vEmz4.8efX8yY4SbgcckJAl7d
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 18 May 2012 11:00:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Rik van Riel <riel@redhat.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
In-Reply-To: <1337356192.573.75.camel@twins>
Message-ID: <alpine.DEB.2.00.1205181057400.21093@router.home>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org> <4FB66756.2060302@redhat.com> <1337355341.573.68.camel@twins> <1337355610.573.70.camel@twins> <alpine.DEB.2.00.1205181047030.21093@router.home> <1337356192.573.75.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Peter Zijlstra wrote:

> On Fri, 2012-05-18 at 10:47 -0500, Christoph Lameter wrote:
> > On Fri, 18 May 2012, Peter Zijlstra wrote:
> >
> > > On Fri, 2012-05-18 at 17:35 +0200, Peter Zijlstra wrote:
> > > > I've also said many times over that I absolutely detest all the async
> > > > stuff because it messes up accounting. And until someone comes up with a
> > > > sane means of sorting that I'll stick to migrate-on-fault.
> > >
> > > The other nice advantage of migrate-on-fault is that you don't have to
> > > play lifetime games with vmas. This much simplifies that aspect.
> >
> > The problem with migrate on fault in the past has been that there was no
> > consistent benefit from the overhead added to the system. Useless page
> > migration is a bit expensive.
>
> I'm not sure I follow.. having the page local is a win, presuming you
> can limit the migration rate to something low in relation to the cost of
> remote accesses.

Having the page local is a win if there are a sufficient number of
accesses to amortize the effort to move the page. Given the expensive
nature of page migration there would need to be a large number of accesses
to a page to justify the effort.

> How does it matter how you migrate?

Migrate on fault incurs two types of costs:

1. Unmapping. This results in additional faults to reestablish the ptes.

2. Actual lazy migrate. More faults. Now the page needs to be copied to
   the new node and the actual migration work is done.

