Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab0FJN4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:56:41 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36794 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757386Ab0FJN4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:56:40 -0400
Date: Thu, 10 Jun 2010 15:56:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marek Vasut <marek.vasut@gmail.com>, julia@diku.dk,
       linux-arm-kernel@lists.infradead.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sa1111: Prevent deadlock in resume path
Message-ID: <20100610135609.GC4514@ucw.cz>
References: <1274901104-22133-1-git-send-email-marek.vasut@gmail.com>
 <20100526191425.GD6232@n2100.arm.linux.org.uk>
 <201005262115.57282.marek.vasut@gmail.com>
 <20100526201824.GA16418@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100526201824.GA16418@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-05-26 21:18:24, Russell King - ARM Linux wrote:
> On Wed, May 26, 2010 at 09:15:57PM +0200, Marek Vasut wrote:
> > Dne St 26. května 2010 21:14:25 Russell King - ARM Linux napsal(a):
> > > On Wed, May 26, 2010 at 09:11:44PM +0200, Marek Vasut wrote:
> > > > This patch reorganises the sa1111_resume() function in a manner the
> > > > spinlock happens after calling the sa1111_wake(). This fixes two bugs:
> > > > 
> > > > 1) This function called sa1111_wake() which tried to claim the same
> > > > spinlock
> > > > 
> > > >    the sa1111_resume() already claimed. This would result in certain
> > > >    deadlock.
> > > >    
> > > >    Original idea for this part: Russell King <linux@arm.linux.org.uk>
> > > > 
> > > > 2) The function didn't unlock the spinlock in case the chip didn't report
> > > > 
> > > >    correct ID.
> > > >    
> > > >    Original idea for this part: Julia Lawall <julia@diku.dk>
> > > > 
> > > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > > 
> > > Yea, good enough.
> > 
> > You want me to fight your patch tracking system or will you just merge it into 
> > your tree ?
> 
> What do you mean "fight" ?  Just send a standard git formatted patch
> to the email address with an additional KernelVersion: tag.  It's
> not at all hard.

You are linux kernel maintainer. Start acting as one. It is not at all
hard.

Alternatively, just remove KernelVersion: checking in  your
scripts.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
