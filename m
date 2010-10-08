Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0JHMPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:15:41 -0400
Received: from www.tglx.de ([62.245.132.106]:44006 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab0JHMPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:15:40 -0400
Date: Fri, 8 Oct 2010 14:15:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
In-Reply-To: <89k83a$9u8ggv@azsmga001.ch.intel.com>
Message-ID: <alpine.LFD.2.00.1010081414130.13094@localhost6.localdomain6>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com> <alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6> <alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6> <89k83a$9u8ggv@azsmga001.ch.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010, Chris Wilson wrote:

> On Thu, 7 Oct 2010 23:35:43 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> > The first test worked fine. But after I added some debugging I got
> > another weird corruption this time on the first unload:
> > 
> > Oct  7 23:21:24 ionos kernel: Console: switching to colour VGA+ 80x25
> > Oct  7 23:21:31 ionos kernel: drm: unregistered panic notifier
> > Oct  7 23:21:31 ionos kernel: vga_switcheroo: disabled
> > Oct  7 23:21:31 ionos kernel: [drm:drm_mm_takedown] *ERROR* Memory manager not clean. Delaying takedown
> > 
> > That one scares me :)
> 
> That was a leak of the object handles which should have been fixed in
> .36-rc2

Emphasis on should. That's rc7
 
> The other horrible crashes look like the set of unload fixes that Daniel
> Vetter supplied for .36-rc3 but we postponed to .37.

Well, then you better prevent the removal of the module until it's fixed.

Thanks,

	tglx


