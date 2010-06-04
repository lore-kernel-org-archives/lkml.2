Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab0FDOZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:25:51 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39948 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932293Ab0FDOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:25:50 -0400
Date: Fri, 4 Jun 2010 16:24:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100604142439.GC1760@ucw.cz>
References: <1273887635-27610-1-git-send-email-venki@google.com>
 <87tyq9mqrz.fsf@basil.nowhere.org>
 <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
 <20100517102635.GB20761@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517102635.GB20761@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, understood.  But the kernel doesn't expose a "gettimeofday
> > performance sucks" flag either.  If it did (or in the case of
> > the patch, if tsc_reliable is zero) the application could at least
> > choose to turn off the 10000-100000 timestamps/second and log
> > a message saying "you are running on old hardware so you get
> > fewer features".
> 
> I don't think anyone would object to exporting such a flag if 
> it's cleanly designed.
> 
> Getting the semantics right for that might be somewhat tricky
> though. How is "slow" defined?

Well... if you want to know how fast gettimeofday is, perhaps doing

gettimeofday(); gettimeofday();

is good enough?

If not, perhaps you can export 'how many clocks is gettimeofday
 expected to take' variable somewhere, but...

								Pavel


> > A CPU-hotplugable system is a good example of a case where
> > the kernel should expose that tsc_reliable is 0.  (I've heard
> 
> That would mean that a large class of systems which
> are always hotplug capable (even if it's not used) 
> would never get fast TSC time.
> 
> Wasn't the goal here to be faster? 
> 
> > anecdotally that CPU hotplug into a QPI or Hypertransport system
> > will have some other interesting challenges, so may require some
> > special kernel parameters anyway.)  Even if tsc_reliable were
> > only enabled if a "no-cpu_hotplug" kernel parameter is set,
> > that is still useful.  And with cores-per-socket (and even
> > nodes-per-socket) going up seemingly every day, multi-socket
> > systems will likely be an ever smaller percentage of new
> > systems.
> 
> Still the people running them will expect as good performance
> as possible.
> 
> -Andi
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
