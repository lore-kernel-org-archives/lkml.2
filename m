Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab0EDHx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:53:27 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45184 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757201Ab0EDHx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:53:26 -0400
Date: Tue, 4 May 2010 06:16:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, mgross@linux.intel.com,
       aili@codeaurora.org, dwalker@codeaurora.org, tiwai@suse.de,
       bruce.w.allan@intel.com, davidb@quicinc.com, mcgrof@gmail.com,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]PM QOS refresh against next-20100430
Message-ID: <20100504041637.GC5326@ucw.cz>
References: <20100430212043.GA30315@linux.intel.com>
 <20100503103300.6330e522@bike.lwn.net>
 <87y6g1547o.fsf@deeprootsystems.com>
 <20100503104250.7605d2bc@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503104250.7605d2bc@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-05-03 10:42:50, Jonathan Corbet wrote:
> On Mon, 03 May 2010 09:40:11 -0700
> Kevin Hilman <khilman@deeprootsystems.com> wrote:
> 
> > > One question, though...  one clear use of this API is for drivers to
> > > say "don't go into C3 or deeper because things go wrong"; I'm about to
> > > add another one of those.  It works, but the use of a
> > > PM_QOS_CPU_DMA_LATENCY requirement with a hard-coded number that one
> > > hopes is small enough seems a bit...indirect.  I wonder if it would be
> > > clearer and more robust to add a new requirement^Wrequest type saying
> > > "the quality of service I need is shallow sleeps only"?  
> > 
> > The problem with that is portability.
> > 
> > What does "shallow" mean?  
> 
> Well, shallow could mean that the state lacks the CPUIDLE_FLAG_DEEP
> flag; that should be relatively portable.  In any case, it seems more
> so than "if I put in a 55us latency requirement, I'll stay out of C3".

While C3 has maximum allowed latency (101usec, iirc), I believe
there's no minimum, so someone could create platform with really quick
C3 with perhaps only 10usec to enter...

								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
