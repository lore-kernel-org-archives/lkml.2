Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0CUJ6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 05:58:12 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:55001 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0CUJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 05:58:10 -0400
X-Greylist: delayed 1542 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Mar 2010 05:58:10 EDT
Date: Sun, 21 Mar 2010 05:32:08 -0400
From: Jon Masters <jonathan@jonmasters.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Tilman Schmidt <t.schmidt@phoenixsoftware.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: should new kfifo implementation really be exporting that much?
Message-ID: <20100321093207.GX4426@perihelion.bos.jonmasters.org>
References: <alpine.LFD.2.00.1003140929350.4644@localhost>
 <alpine.LFD.2.00.1003141053380.5987@localhost>
 <4B9D10D1.1060602@phoenixsoftware.de>
 <alpine.LFD.2.00.1003141244280.7806@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003141244280.7806@localhost>
Organization: World Organi[sz]ation of Broken Dreams
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jcm@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 12:49:08PM -0400, Robert P. J. Day wrote:
> On Sun, 14 Mar 2010, Tilman Schmidt wrote:
> 
> > Am 14.03.2010 15:57 schrieb Robert P. J. Day:
> > >   as a short followup, kfifo.h strongly implies that a lot of the
> > > above shouldn't be exported:
> > >
> > > ...
> > > /*
> > >  * __kfifo_in_... internal functions for put date into the fifo
> > >  * do not call it directly, use kfifo_in_rec() instead
> > >  */
> > > ...
> > >
> > >   anyway, you get the idea.  it would seem that a lot of those EXPORTs
> > > should be removed, no?
> >
> > If you look at kfifo_in_rec(), it's a static inline void function
> > defined in kfifo.h and which calls __kfifo_in_generic() or
> > __kfifo_in_rec(). I don't think you'll be able to make that work
> > without exporting those functions.
> 
>   huh.  i believe you're correct.  i'll take a closer look but i still
> get this feeling that there's something ... messy about that API.
> case in point:  kfifo_in_rec() is *not* being exported, but a routine
> that it invokes -- __kfifo_in_generic() -- *is* being exported.
> doesn't that just seem a bit backwards?

I believe it would be a good idea to have an export type explicitly
covering symbols that are exported solely for the use of inlines,
just for tidying up these situations. EXPORT_SYMBOL_INTERNAL?

Jon.
