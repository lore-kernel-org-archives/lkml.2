Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0JDR4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:56:10 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58037 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755082Ab0JDR4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:56:08 -0400
Date: Mon, 4 Oct 2010 19:56:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@tuxonice.net>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM / Hibernate: Modify signature used to mark swap
Message-ID: <20101004175600.GE1518@ucw.cz>
References: <201009292313.23601.rjw@sisk.pl>
 <4CA3ADED.6090908@tuxonice.net>
 <201009300002.03412.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009300002.03412.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Index: linux-2.6/kernel/power/swap.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/power/swap.c
> > > +++ linux-2.6/kernel/power/swap.c
> > > @@ -29,7 +29,7 @@
> > >
> > >   #include "power.h"
> > >
> > > -#define SWSUSP_SIG	"S1SUSPEND"
> > > +#define HIBERNATE_SIG	"LINHIB0001"
> > >
> > >   /*
> > >    *	The swap map is a data structure used for keeping track of each page
> > > @@ -195,7 +195,7 @@ static int mark_swapfiles(struct swap_ma
> > >   	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
> > >   	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
> > >   		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
> > 
> > if no compression
> > 
> > > -		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
> > 
> > else
> > 
> > > +		memcpy(swsusp_header->sig, HIBERNATE_SIG, 10);
> > 
> > ??
> 
> I thought about that, but we'll need to drop the old signature when the image
> format changes (I think it will after your patch series) anyway.  And the
> benefit is not really worth it IMO (it only affects people using the in-kernel
> hibernation on x86-64).
> 

ACK. Lets keep this simple.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
