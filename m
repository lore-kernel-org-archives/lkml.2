Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2ASRkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:40:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39512 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2ASRkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:40:39 -0500
Date: Thu, 19 Jan 2012 18:40:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
Message-ID: <20120119174038.GA25397@atrey.karlin.mff.cuni.cz>
References: <201201180015.56510.rjw@sisk.pl>
 <4F16C24A.4050007@linux.vnet.ibm.com>
 <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com>
 <4F16F94C.4020000@linux.vnet.ibm.com>
 <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com>
 <4F16FF0D.1030606@linux.vnet.ibm.com>
 <20120118173037.GE30664@google.com>
 <20120118173348.GF30664@google.com>
 <20120119103707.GA13308@elf.ucw.cz>
 <4F17F6AF.10604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F17F6AF.10604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> To give an example,
> >>
> >> 	/*
> >> 	 * XXX: Open code SKIP clearing for now to avoid invoking
> >> 	 * try_to_freeze().  This isn't correct but this function is
> >> 	 * called from deep inside hibernation path and calling
> >> 	 * try_to_freeze() leads to hang during hibernation.  This
> >> 	 * will be properly fixed soon.  See commit message for
> >> 	 * more details.
> >> 	 */
> > 
> > Which paths are affected?
> > 
> > With uswsusp, we have userland in control of hibernation process; I'd
> > say almost anything can be called...
> 
> 
> Hi Pavel,
> I am afraid you are looking at a stale comment. We finalized on a
> different comment altogether.

I know. But the underlying problem (uswsusp code is userland, and can
do anything) is still there, right? I guess limitations for
applications using uswsusp interface should be documented somewhere.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
