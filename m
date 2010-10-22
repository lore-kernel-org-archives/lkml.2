Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab0JVRDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:03:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45376 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0JVRDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:03:34 -0400
Date: Fri, 22 Oct 2010 11:03:30 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tony Lindgren <tony@atomide.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Balaji T K <balajitk@ti.com>, "Kamat, Nishant" <nskamat@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Benoit Cousson <b-cousson@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
Message-ID: <20101022170330.GC9445@angua.secretlab.ca>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com>
 <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <87bp6pviwf.fsf@deeprootsystems.com>
 <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
 <8739s0sobc.fsf@deeprootsystems.com>
 <AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
 <20101022165612.GF9149@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022165612.GF9149@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 09:56:13AM -0700, Tony Lindgren wrote:
> * Ohad Ben-Cohen <ohad@wizery.com> [101020 12:12]:
> > On Wed, Oct 20, 2010 at 8:37 PM, Kevin Hilman
> > <khilman@deeprootsystems.com> wrote:
> > >> Let's take the i2c-omap for example.
> > >>
> > >> It sounds like it must have a predefined hwspinlock, but what if:
> > >>
> > >> 1. It will use omap_hwspinlock_request() to dynamically allocate a hwspinlock
> > >> 2. Obviously, the hwspinlock id number must be communicated to the M3
> > >> BIOS, so the i2c-omap will publish that id using a small shared memory
> > >> entry that will be allocated for this sole purpose
> > >> 3. we will make sure that 1+2 completes before the remote processor is
> > >> taken out of reset
> 
> Guys, let's try to come up with a generic interface for this instead of
> polluting the device drivers with more omap specific interfaces.
> 
> We really want to keep the drivers generic and platform independent.
> 
> Sure we still have some omap specific stuff in the drivers, like
> cpu_is_omapxxxx, and omap specific dma calls, but those will be going
> away.
> 
> Unless somebody has better ideas, I suggest we pass a lock function
> in the platform_data to the drivers that need it, and do the omap
> specific nasty stuff in the platform code.

For those of you going to plumbers, I'll put this on the embedded
microconference agenda when we're talking about common infrastructure.

g.

