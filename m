Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab0FJWev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 18:34:51 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:44552 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759876Ab0FJWer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 18:34:47 -0400
Message-Id: <201006102231.AA00430@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Fri, 11 Jun 2010 07:31:39 +0900
To: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       TAMUKI Shoichi <tamuki@linet.gr.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100610023033.GN28295@kryten>
References: <20100610023033.GN28295@kryten>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, 10 Jun 2010 12:30:33 +1000 Anton Blanchard wrote:

> > Please remind me why we're making this configurable at all.  Can't we
> > just hardwire the thing to 1Hz or something?  Add an
> > im_using_a_hypervisor boot option or something, if necessary?
> 
> I agree. The panic_blink() interface is quite painful and I have no idea
> why someone would want to configure the blink frequency of their keyboard
> LED when panicing. Maybe they want to match it to the beat of their techno
> music.

That's cool.  Joking aside, we might want to know which machine has
paniced among two or more overcrowded machines.  Maybe it is a good
idea to change the blinking speed of each machine so as to distinguish
whether the machine has paniced or not.

> Since the keyboard LED default is a transition every 0.5s, why don't we just
> remove i8042.panicblink and change all users (all 2 of them) to expect a 2 HZ
> call rate? The hypervisor case should be fine with 0.5s mdelays, so we end up
> removing that special case.

If the speed of blinking is slow enough (i.e. panicblink<=5), both the
native case and the hypervisor case should be fine, indeed.  However,
gta02_panic_blink(), one of panic_blink() users, expects a 10Hz call
rate at the native case.  IOW, it blinks at 5Hz (i.e. panicblink=36).
I think that the desirable blinking speed is different according to
devices.

> I would have said 1 HZ, but it seems like the default was chosen to be
> different to kdb:
> 
> 	/*
>          * We expect frequency to be about 1/2s. KDB uses about 1s.
>          * Make sure they are different.
> 	 */
> 
> No idea if that comment is still valid.

That comment maybe still valid according to the following:

On Sun, 30 May 2010 08:55:22 +0200 Andi Kleen wrote:

> Changing the frequency is ok, the only requirement is that it is
> visible and different from the frequency kdb uses.

Regards,
TAMUKI Shoichi
