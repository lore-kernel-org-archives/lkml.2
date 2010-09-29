Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab0I2WDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 18:03:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab0I2WDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 18:03:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [RFC][PATCH] PM / Hibernate: Modify signature used to mark swap
Date: Thu, 30 Sep 2010 00:02:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201009292313.23601.rjw@sisk.pl> <4CA3ADED.6090908@tuxonice.net>
In-Reply-To: <4CA3ADED.6090908@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009300002.03412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 29, 2010, Nigel Cunningham wrote:
> Hi.
> 
> On 30/09/10 07:13, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki<rjw@sisk.pl>
> > Subject: PM / Hibernate: Modify signature used to mark swap
> >
> > Since we are adding compression to the kernel's hibernate code,
> > change signature used by it to mark swap spaces, so that earlier
> > kernels don't attempt to restore compressed images they cannot
> > handle.
> >
> > Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> > ---
> >   kernel/power/swap.c |    6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > Index: linux-2.6/kernel/power/swap.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/power/swap.c
> > +++ linux-2.6/kernel/power/swap.c
> > @@ -29,7 +29,7 @@
> >
> >   #include "power.h"
> >
> > -#define SWSUSP_SIG	"S1SUSPEND"
> > +#define HIBERNATE_SIG	"LINHIB0001"
> >
> >   /*
> >    *	The swap map is a data structure used for keeping track of each page
> > @@ -195,7 +195,7 @@ static int mark_swapfiles(struct swap_ma
> >   	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
> >   	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
> >   		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
> 
> if no compression
> 
> > -		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
> 
> else
> 
> > +		memcpy(swsusp_header->sig, HIBERNATE_SIG, 10);
> 
> ??

I thought about that, but we'll need to drop the old signature when the image
format changes (I think it will after your patch series) anyway.  And the
benefit is not really worth it IMO (it only affects people using the in-kernel
hibernation on x86-64).

Thanks,
Rafael
