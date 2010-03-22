Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab0CVOem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:34:42 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:50347 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab0CVOek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:34:40 -0400
Date: Mon, 22 Mar 2010 10:32:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Jon Masters <jonathan@jonmasters.org>
cc: Tilman Schmidt <t.schmidt@phoenixsoftware.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: should new kfifo implementation really be exporting that much?
In-Reply-To: <20100321093207.GX4426@perihelion.bos.jonmasters.org>
Message-ID: <alpine.LFD.2.00.1003221030360.25001@localhost>
References: <alpine.LFD.2.00.1003140929350.4644@localhost> <alpine.LFD.2.00.1003141053380.5987@localhost> <4B9D10D1.1060602@phoenixsoftware.de> <alpine.LFD.2.00.1003141244280.7806@localhost> <20100321093207.GX4426@perihelion.bos.jonmasters.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, Jon Masters wrote:

> On Sun, Mar 14, 2010 at 12:49:08PM -0400, Robert P. J. Day wrote:
> > On Sun, 14 Mar 2010, Tilman Schmidt wrote:
> >
> > > Am 14.03.2010 15:57 schrieb Robert P. J. Day:
> > > >   as a short followup, kfifo.h strongly implies that a lot of the
> > > > above shouldn't be exported:
> > > >
> > > > ...
> > > > /*
> > > >  * __kfifo_in_... internal functions for put date into the fifo
> > > >  * do not call it directly, use kfifo_in_rec() instead
> > > >  */
> > > > ...
> > > >
> > > >   anyway, you get the idea.  it would seem that a lot of those EXPORTs
> > > > should be removed, no?
> > >
> > > If you look at kfifo_in_rec(), it's a static inline void
> > > function defined in kfifo.h and which calls __kfifo_in_generic()
> > > or __kfifo_in_rec(). I don't think you'll be able to make that
> > > work without exporting those functions.
> >
> >   huh.  i believe you're correct.  i'll take a closer look but i
> > still get this feeling that there's something ... messy about that
> > API. case in point:  kfifo_in_rec() is *not* being exported, but a
> > routine that it invokes -- __kfifo_in_generic() -- *is* being
> > exported. doesn't that just seem a bit backwards?
>
> I believe it would be a good idea to have an export type explicitly
> covering symbols that are exported solely for the use of inlines,
> just for tidying up these situations. EXPORT_SYMBOL_INTERNAL?

  i wasn't suggesting anything as drastic as inventing a new export
level :-), i just wanted to verify that the current situation as to
what's currently exported related to kfifo just seemed a bit odd and
inconsistent.  but a new export level might support the removal of a
considerable amount from the fully-exported namespace.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
