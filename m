Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab1GYVkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:40:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:34144 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1GYVkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,264,1309762800"; 
   d="scan'208";a="34370260"
Date: Mon, 25 Jul 2011 22:42:50 +0100
From: Alan Cox <alan@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ryan Mallon <rmallon@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: Re: GMA500: ERROR: "__bad_udelay" undefined!
Message-ID: <20110725224250.7d6edb83@bob.linux.org.uk>
In-Reply-To: <62472696.BtqhiR95vr@wuerfel>
References: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net>
	<4E2CC55B.5010307@gmail.com>
	<4E2CC6CC.5020204@gmail.com>
	<62472696.BtqhiR95vr@wuerfel>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011 23:08:42 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 25 July 2011 11:28:44 Ryan Mallon wrote:
> > 
> > diff --git a/drivers/staging/gma500/psb_intel_display.c
> > b/drivers/staging/gma500/psb_intel_display.c index 4f47d09..09e378d
> > 100644 --- a/drivers/staging/gma500/psb_intel_display.c
> > +++ b/drivers/staging/gma500/psb_intel_display.c
> > @@ -331,7 +331,7 @@ static bool psb_intel_find_best_PLL(struct
> > drm_crtc *crtc, int target, void psb_intel_wait_for_vblank(struct
> > drm_device *dev) {
> >         /* Wait for 20ms, i.e. one cycle at 50hz. */
> > -       udelay(20000);
> > +       mdelay(20);
> >   }
> > 
> >   int psb_intel_pipe_set_base(struct drm_crtc *crtc,
> 
> A 20 ms busy wait is rather nasty. Can't this be replaced with a
> sleeping wait (msleep)?

Don't know yet - its on the fixme list to dig into - I think the answer
is some cases but not all.
