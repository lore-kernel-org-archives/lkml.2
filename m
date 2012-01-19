Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2ASKhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:37:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53716 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2ASKhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:37:11 -0500
Date: Thu, 19 Jan 2012 11:37:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
Message-ID: <20120119103707.GA13308@elf.ucw.cz>
References: <201201172345.15010.rjw@sisk.pl>
 <201201180015.56510.rjw@sisk.pl>
 <4F16C24A.4050007@linux.vnet.ibm.com>
 <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com>
 <4F16F94C.4020000@linux.vnet.ibm.com>
 <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com>
 <4F16FF0D.1030606@linux.vnet.ibm.com>
 <20120118173037.GE30664@google.com>
 <20120118173348.GF30664@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118173348.GF30664@google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I agree, but I was trying to keep the comment from growing too long ;)
> > 
> > It doesn't have to be long.  It just has to give some meaning to the
> > decision.  AFAICS, it is correct to call try_to_freeze() on
> > unlock_system_sleep() regardless of 20sec window.  There's no
> > guarantee the unlocking task is gonna hit try_to_freeze() elsewhere
> > and not calling it actually makes the interface buggy.
> 
> To give an example,
> 
> 	/*
> 	 * XXX: Open code SKIP clearing for now to avoid invoking
> 	 * try_to_freeze().  This isn't correct but this function is
> 	 * called from deep inside hibernation path and calling
> 	 * try_to_freeze() leads to hang during hibernation.  This
> 	 * will be properly fixed soon.  See commit message for
> 	 * more details.
> 	 */

Which paths are affected?

With uswsusp, we have userland in control of hibernation process; I'd
say almost anything can be called...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
