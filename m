Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0DUGUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 02:20:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59983 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab0DUGUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 02:20:20 -0400
Date: Wed, 21 Apr 2010 08:20:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #15672] KVM bug, git bisected
Message-ID: <20100421062015.GB3839@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
 <4BCE188A.1060408@redhat.com>
 <4BCE72D6.6010809@redhat.com>
 <201004210702.02129.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201004210702.02129.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, Apr 21, 2010 at 07:02:02AM +0200

> On Wednesday 21 April 2010, Rik van Riel wrote:
> > On 04/20/2010 05:11 PM, Rik van Riel wrote:
> > > On 04/19/2010 11:19 PM, Rafael J. Wysocki wrote:
> > >> This message has been generated automatically as a part of a summary
> > >> report
> > >> of recent regressions.
> > >>
> > >> The following bug entry is on the current list of known regressions
> > >> from 2.6.33. Please verify if it still should be listed and let the
> > >> tracking team
> > >> know (either way).
> > >>
> > >>
> > >> Bug-Entry : http://bugzilla.kernel.org/show_bug.cgi?id=15672
> > >> Subject : KVM bug, git bisected
> > >> Submitter : Kent Overstreet<kent.overstreet@gmail.com>
> > >> Date : 2010-03-27 12:43 (24 days old)
> > >> First-Bad-Commit:
> > >> http://kernel.org/git/linus/5beb49305251e5669852ed541e8e2f2f7696c53e
> > >> Message-ID :<4BADFD74.8060904@gmail.com>
> > >> References : http://marc.info/?l=linux-kernel&m=126969385121711&w=2
> > >
> > > Should be fixed by commit ea90002b0fa7bdee86ec22eba1d951f30bf043a6
> > 
> > Never mind me - this is a harmless (but loud) overflow
> > of PREEMPT_BITS in the preempt count.
> 
> OK, what am I supposed to do with this entry, then?  Close?

FWIW, I hit that warning too when chasing the anon_vma regression. It
seems on certain workloads (for me it was several kvm guests) we're
close to max preemption depth.

Anyway, adding some more people to Cc.

-- 
Regards/Gruss,
    Boris.
