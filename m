Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0EXS5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:57:48 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33173 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756023Ab0EXS5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:57:46 -0400
Date: Mon, 24 May 2010 20:57:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: James Kosin <james.kosin.04@cnu.edu>, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100524185735.GC1292@ucw.cz>
References: <eGToe-3b9-5@gated-at.bofh.it>
 <eGUaB-4mU-1@gated-at.bofh.it>
 <eGUtX-4Kd-3@gated-at.bofh.it>
 <eGWvL-7Fy-1@gated-at.bofh.it>
 <eGWFt-7S7-17@gated-at.bofh.it>
 <eGWP9-8jH-17@gated-at.bofh.it>
 <4BE37DDD.8000402@cox.net>
 <p2jd6200be21005061953y497b0766k15123f69ff7db630@mail.gmail.com>
 <4BE38290.6040404@cnu.edu>
 <g2rd6200be21005062010s1a490b3dref465f5df64b8f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <g2rd6200be21005062010s1a490b3dref465f5df64b8f7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> Tony,
> >>> Wouldn't this be handled by the idle task, or task manager?
> >>>
> >>> When all tasks are suspended and not doing anything that should be the
> >>> first clue that a real suspend cycle could be attempted.
> >>>
> >>>
> >> One if the benefit we get from using suspend is that an unprivileged
> >> app that does not have access to suspend blockers cannot prevent
> >> suspend. You lose this advantage if you trigger suspend only from the
> >> idle task.
> >>
> >>
> > If the process (privileged or unprivileged) doesn't want to suspend, why
> > not just provide an interface to allow suspend to be turned off at the
> > user level.  This could block the suspend cycle in itself, and you
> > shouldn't need fine grained off/on cycles.  If an application really
> > needs the system not to suspend then they (the user) should know the
> > consequences and power requirements for such a task.
> >
> > I didn't say it had to be only from the idle task; but, that is the most
> > logical place.  If the other threads are not idle then they really
> > require work and will most likely already have a bock on the suspend anyway.

> I think you missed my point. Unprivileged processes should not be
> allowed to prevent suspend.

Currently, we do not suspend automatically, and not suspending when
*anything* is running is clearly backwards compatible....

 If suspend is disallowed, application doing while(1); will consume
more power than the one doing sleep(1) so.... I'm not sure how much
sense such "security policy" makes.

Anyway, for android use case, maybe you could have something like
ksuspendd, and adjust its priority? That way, you could have tasks
below the priority of ksuspendd, and those would not block suspend.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
