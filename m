Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0EZPOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:14:12 -0400
Received: from www.tglx.de ([62.245.132.106]:59164 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0EZPOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:14:09 -0400
Date: Wed, 26 May 2010 17:13:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Egger <siccegge@cs.fau.de>
cc: Ralf Baechle <ralf@linux-mips.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jon Hunter <jon-hunter@ti.com>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] transitional config CONFIG_GENERIC_CLOCKEVENTS
In-Reply-To: <20100526145700.GA5475@faui48a.informatik.uni-erlangen.de>
Message-ID: <alpine.LFD.2.00.1005261708420.2995@localhost.localdomain>
References: <20100526134415.GD7508@faui49.informatik.uni-erlangen.de> <alpine.LFD.2.00.1005261554280.2995@localhost.localdomain> <20100526145700.GA5475@faui48a.informatik.uni-erlangen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Christoph Egger wrote:

> On Wed, May 26, 2010 at 03:56:09PM +0200, Thomas Gleixner wrote:
> > On Wed, 26 May 2010, Christoph Egger wrote:
> > 
> > > Hi all!
> > > 
> > > 	As part of the VAMOS[0] research project at the University of
> > > Erlangen we are looking at multiple integrity errors in linux'
> > > configuration system.
> > > 
> > > 	This was an aid for a transition finished 2007 so not
> > > necessary for some time now, ready for removal.
> > > 
> > > 	Please keep me informed of this patch getting confirmed /
> > > merged so we can keep track of it.
> > 
> > It's still necessary/helpful for any arch which is not yet
> > converted. And there are a few unfortunately.
> 
> 	Are you referring to some out-of-tree architectures? I've
> verified the string GENERIC_CLOCKEVENTS_MIGR is only appearing at this
> single spot in kconfig and nowhere else in code/Kconfig in my
> up-to-date linux tree.

No. I'm referring to in tree archs which do not use the clock events
at all yet. The MIGR symbol allows them to do a step by step
conversion which builds the generic clock events stuff first before
switching over to use them. That's why it was created in the first
place and it has been proven useful when doing such work. So I'd
rather see it stay until all archs actually use the generic framework.

But yes, we can apply your patch and just let them select
GENERIC_CLOCKEVENTS_BUILD instead.

Thanks,

	tglx
