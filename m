Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0ESJDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:03:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49514 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab0ESJDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:03:30 -0400
Date: Wed, 19 May 2010 11:03:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@amd64.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100519090323.GA18073@basil.fritz.box>
References: <4BF18995.6070008@redhat.com> <4BF2392A.9040409@jp.fujitsu.com> <4BF2C3D1.10009@redhat.com> <1274204560.17703.82.camel@Joe-Laptop.home> <20100518185305.GA23921@elte.hu> <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com> <20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org> <20100518222832.GJ22675@basil.fritz.box> <m1wrv0zo9q.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrv0zo9q.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

> I'm not ready to believe the average person that is running linux
> is too stupid to understand the difference between a hardware
> error and a software error.

Experience disagrees with you (that is not sure about average,
but at least there's a significant portion) 

Also again today there are other reasons for it.

> 
> > But there's more to it now:
> >
> >> If your system isn't broken correctable errors are rare.  People look
> >
> > Actually the more memory you have the more common they are.
> > And the trend is to more and more memory.
> 
> The error rate should not be fixed per bit but should be roughly fixed
> per DIMM.  If the error rate over time is fixed per bit we are in deep
> trouble.

Error rates of good DIMMs scale roughly with the number of transistors.
It's not the only influence though, but a major one.

> > Really to do anything useful with them you need trends
> > and automatic actions (like predictive page offlining)
> 
> Not at all, and I don't have a clue where you start thinking
> predictive page offlining makes the least bit of sense.  Broken
> or even weak bits are rarely the common reason for ECC errors.

There are various studies that disagree with you on that.

> 
> > A log isn't really a good format for that
> 
> A log is a fine format for realizing you have a problem.  A

A low steady rate of corrected errors on a large system
is expected.  In fact if you look at the memory error log.
of a large system (towards TBs) it nearly always has some 
memory related events.

In this case a log is not really useful. What you need
is useful thresholds and a good summary.

> - Errors that occur frequently. That is broken hardware of one time or
>   another.  I want to know about that so I can schedule down time to replace
>   my memory before I get an uncorrected ECC error.  Errors of this kind
>   are likely happening frequently enough as to impact performance.

Same issue here: if something is truly broken it floods
you with errors.

First this costs a lot of time to process and it does not 
actually tell you anything useful because most errors in a flood
are similar.

Basically you don't care if you have 100 or 1000 errors, 
and you definitely don't want all the of the errors filling up
your disk and using up your CPU.

Again a threshold with an action is much more useful here.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
