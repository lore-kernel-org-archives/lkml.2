Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0HHVrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 17:47:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48107 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0HHVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 17:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VyPKRcPHPxTCYxT9FxyKQ7MRO4v/RiAAlBsklAgH507abVzoe2AvuAp3eow7dYaAd5
         qX9HxOCc64qVmcP0bm3B964rUwdsmUqliYNwjWBKe2uVeHdHwrcesd27hVPIL8AbjdYe
         vdYN6QoSv39ElOUdHo1KU75Op9oRo9eXnyj8k=
Date: Sun, 8 Aug 2010 23:47:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend
	on LOCKUP_DETECTOR
Message-ID: <20100808214745.GB5387@nowhere>
References: <4C58C7FF.5060906@cn.fujitsu.com> <20100806005801.GB5436@nowhere> <20100807070135.GC23108@elte.hu> <20100808195839.GA5387@nowhere> <20100808212311.GA7194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100808212311.GA7194@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 08, 2010 at 11:23:11PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > The thing is, CONFIG_DETECT_SOFTLOCKUP was default-y before, so many 
> > > people had it enabled [and had it forced-enabled if DEBUG_KERNEL was off], 
> > > even if they didnt really want or need it.
> > 
> > Hmm. It was:
> > 
> > config DETECT_SOFTLOCKUP
> > 	bool "Detect Soft Lockups"
> > 	depends on DEBUG_KERNEL && !S390
> > 	default y
> > 
> > It means it's default enabled only if DEBUG_KERNEL, right? Then if you don't 
> > select CONFIG_DEBUG_KERNEL, it's fine as it won't be selected.
> 
> Indeed, you are right.
> 
> Anyway, i think the general point remains: i'm not sure we should 
> default-enable this feature.



Yeah, right.


 
> > But I agree with you. There is a bunch of config options for which selection 
> > is a duty when you are a kernel developer: PROVE_LOCKING, DETECT_HUNG_TASK, 
> > DEBUG_PREEMPT, PROVE_RCU, etc... Because they all show (or prove we can 
> > have) bugs that one might miss without these options. Softlockups are rarely 
> > part of them because even without the lockup detector enabled, you'll 
> > observe something is wrong.
> 
> Note that it's now detecting all kinds of lockups: softlockups, hard lockups 
> and even unkillable hung tasks.
> 
> 	Ingo



The unkillable hung task detector remains seperate. May be from the config point
of view it could be joined, but from an implementation point of view it has too
few to share with the lockup detector: it doesn't need a real time task, nor
a timer, etc...

