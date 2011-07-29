Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1G2TtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:49:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47153 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1G2TtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:49:14 -0400
Date: Fri, 29 Jul 2011 21:49:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matt Mackall <mpm@selenic.com>
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110729194903.GA1720@ucw.cz>
References: <m2pql2c0qz.fsf@firstfloor.org>
 <20110722163335.2df4f6ca@notabene.brown>
 <1311363269.14555.261.camel@calx>
 <20110722205922.GS8006@one.firstfloor.org>
 <1311369102.14555.268.camel@calx>
 <20110722214732.GW8006@one.firstfloor.org>
 <20110722221039.GB10749@fieldses.org>
 <20110722223158.GC10749@fieldses.org>
 <20110723085915.308ddc02@notabene.brown>
 <1311379661.20898.23.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311379661.20898.23.camel@calx>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If not, we probably should tell NFSv4 to use timestamps and focus on making
> > them work well.
> > ??
> > 
> > The timestamp used doesn't need to update ever nanosecond.  I think if it
> > were just updated on every userspace->kernel transition  (or effective
> > equivalents inside kernel threads) that would be enough capture all
> > causality.  I wonder how that would be achieved..  I wonder if RCU machinery
> > could help - doesn't it keep track of when threads schedule ... or something?
> 
> Sort of.
> 
> Some observations:
> 
> - we only need to go to higher resolution when two events happen in the
> same time quantum
> - this applies at both the level of seconds and jiffies
> - if the only file touched in a given quantum gets touched ago, we don't
> need to update its timestamp if stat wasn't also called on it in this
> quantum

parse error aroound 'ago'.

> - we never need to use a higher resolution than the global
> min(s_time_gran)
> 
> 
> For instance, if a machine is idle, except for writing to a single file
> once a second, 1s resolution suffices.

Are you sure? As soon as you get network communication...

> Any time two files are touched in the same second, the second one (and
> later files) needs jiffies resolution. Similarly, any time two files are
> touched in the same jiffy, the second one should use gtod().

For make. I don't see how this is globally true.

I do

( date; > stamp; date ) | ( sleep 5; cat > counterexample )

I know timestamp should be between two dates, but it is not.

								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
