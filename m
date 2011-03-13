Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1CMK2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:28:40 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35328 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755276Ab1CMK2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:28:33 -0400
Date: Sun, 13 Mar 2011 11:28:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Soren Hansen <soren@linux2go.dk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <haveblue@us.ibm.com>
Subject: Re: nbd locking problems
Message-ID: <20110313102756.GD1827@ucw.cz>
References: <AANLkTimP=5A-BNHUwV0qhvjw8y4HevMvXtOBpRr6vFYR@mail.gmail.com>
 <20110128211825.GA20707@mail.hallyn.com>
 <AANLkTi=1ubso_qg1dr+xOaF4s=f0Jfzchinh3dnY7jjY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=1ubso_qg1dr+xOaF4s=f0Jfzchinh3dnY7jjY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > In the meantime, could you please post your patch?  (Is it the
> > three-liner I'd expect?)
> 
> Indeed it is. I was holding off on posting it, because I was hoping
> Pavel Machek would chime in. Pavel's commit message in [1] suggested
> that there was more work to do before the BKL could be vanquished from
> this driver (by changing .ioctl to .unlocked_ioctl).

Well, I tried to figure out locking in nbd, but could not. It somehow
wants both transmit and receive protected... but at the same time it
needs receiving while it transmits. Not sure what to do there.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
