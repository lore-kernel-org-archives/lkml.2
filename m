Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab1C3RAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:00:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:43711 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932777Ab1C3RAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:00:36 -0400
Date: Wed, 30 Mar 2011 19:00:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] irq fixes for .39.rc
In-Reply-To: <AANLkTikeMFpxVW2bU+CXh=VVPBf2Tm4ccMFBUELSeVy4@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103301856550.22418@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103301648460.22418@localhost6.localdomain6> <AANLkTinnGfpVeugk4WOKeDAUQEuzBo75yCq_E73=w66V@mail.gmail.com> <alpine.LFD.2.00.1103301827530.22418@localhost6.localdomain6> <alpine.LFD.2.00.1103301845020.22418@localhost6.localdomain6>
 <AANLkTikeMFpxVW2bU+CXh=VVPBf2Tm4ccMFBUELSeVy4@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1577517588-1301504431=:22418"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1577517588-1301504431=:22418
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 30 Mar 2011, Linus Torvalds wrote:

> On Wed, Mar 30, 2011 at 9:46 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 30 Mar 2011, Thomas Gleixner wrote:
> >> On Wed, 30 Mar 2011, Linus Torvalds wrote:
> >> >
> >> > which just makes me go "Somebody is really really confused".
> >> >
> >> > The whole thing may mean that both handler_data and chip_data contains
> >> > the right thing, but it still makes me go "WTF?".
> >> >
> >> > Which way should I resolve it?
> >>
> >> get_irq_desc_data() maps to irq_desc_get_handler_data() so Richards
> >> resolution is correct even if the other might work as well.
> >
> > Older code which was not using any accessors has:
> >
> >      desc->handler_data
> >
> > But yeah, the init stuff is confusing as hell.
> 
> So I took the handler_data version, but I do think the chip_data one
> seems to make more conceptual sense. It would be good if somebody who
> can actually test that code and knows all the details of the
> particular irq controller could just take a look, and decide on using
> one or the other, and not both.

I think I figured it out. The cascade interrupts do not set chip_data,
they set handler data in qe_ic_init().

The interrupts which are demultiplexed by the cascade handlers set
chip_data on different irq_desc instances. So Ben's resolution would
have resulted in a NULL pointer dereference.

Thanks,

	tglx
---1463795968-1577517588-1301504431=:22418--
