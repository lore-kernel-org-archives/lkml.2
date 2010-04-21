Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0DUP5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:57:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56127 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab0DUP5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:57:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #15672] KVM bug, git bisected
Date: Wed, 21 Apr 2010 17:57:23 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <20100421062015.GB3839@liondog.tnic> <1271839554.1776.56.camel@laptop>
In-Reply-To: <1271839554.1776.56.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004211757.23469.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 April 2010, Peter Zijlstra wrote:
> On Wed, 2010-04-21 at 08:20 +0200, Borislav Petkov wrote:
> > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Date: Wed, Apr 21, 2010 at 07:02:02AM +0200
> > 
> > > On Wednesday 21 April 2010, Rik van Riel wrote:
> > > > On 04/20/2010 05:11 PM, Rik van Riel wrote:
> > > > > On 04/19/2010 11:19 PM, Rafael J. Wysocki wrote:
> > > > >> This message has been generated automatically as a part of a summary
> > > > >> report
> > > > >> of recent regressions.
> > > > >>
> > > > >> The following bug entry is on the current list of known regressions
> > > > >> from 2.6.33. Please verify if it still should be listed and let the
> > > > >> tracking team
> > > > >> know (either way).
> > > > >>
> > > > >>
> > > > >> Bug-Entry : http://bugzilla.kernel.org/show_bug.cgi?id=15672
> > > > >> Subject : KVM bug, git bisected
> > > > >> Submitter : Kent Overstreet<kent.overstreet@gmail.com>
> > > > >> Date : 2010-03-27 12:43 (24 days old)
> > > > >> First-Bad-Commit:
> > > > >> http://kernel.org/git/linus/5beb49305251e5669852ed541e8e2f2f7696c53e
> > > > >> Message-ID :<4BADFD74.8060904@gmail.com>
> > > > >> References : http://marc.info/?l=linux-kernel&m=126969385121711&w=2
> > > > >
> > > > > Should be fixed by commit ea90002b0fa7bdee86ec22eba1d951f30bf043a6
> > > > 
> > > > Never mind me - this is a harmless (but loud) overflow
> > > > of PREEMPT_BITS in the preempt count.
> > > 
> > > OK, what am I supposed to do with this entry, then?  Close?
> > 
> > FWIW, I hit that warning too when chasing the anon_vma regression. It
> > seems on certain workloads (for me it was several kvm guests) we're
> > close to max preemption depth.
> > 
> > Anyway, adding some more people to Cc.
> 
> Right, so my proposed solution to this is to make those locks
> preemptible, but that's a large and unfinished patch-set.
> 
> As it is, its only a warning, nothing really serious should happen, but
> the situation does suck.

I'm not sure if it's worth keeping that listed, though, as the problem is known
and won't be solved before .34 final.

OK to close as "will fix later"?

Rafael
