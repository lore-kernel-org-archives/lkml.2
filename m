Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab0KPXKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:10:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab0KPXKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:10:24 -0500
Subject: Re: [PATCH v2 0/2] Fix nouveau-related freezes
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Andrew Lutomirski <luto@mit.edu>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimM6EUeFiyaH=6bkes19LtYO6t1PJL_SE9Zt3-L@mail.gmail.com>
References: <cover.1289430026.git.luto@mit.edu>
	 <AANLkTimM6EUeFiyaH=6bkes19LtYO6t1PJL_SE9Zt3-L@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 09:09:57 +1000
Message-ID: <1289948997.2311.16.camel@nisroch>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 17:19 -0500, Andrew Lutomirski wrote:
> On Wed, Nov 10, 2010 at 6:04 PM, Andy Lutomirski <luto@mit.edu> wrote:
> > Nouveau takes down my system quite reliably when any hotplug event occurs.
> > The bug happens because the IRQ handler didn't acknowledge the hotplug
> > state until the bottom half, so the card generated a new interrupt
> > immediately, starving the bottom half and permanently starving that CPU
> > (and hence the bottom half).
> >
> > Even with this fix, a lot of the IRQ code looks rather broken.
> >
> > This is tested on 2.6.36 (and makes the system stable for me), but it also
> > applies cleanly to 2.6.37 (untested, but surely also necessary).  Fedora 14's
> > 2.6.35 kernels seem to have to same problem for me, so I suspect that 2.6.35
> > needs this fix as well.  (All of my tests are on an NV50 card.)
> >
> > Changes from v1:
> >  - Ignore unrequested hotplug bits (I accidentally removed that part).
> >  - Support newer hardware (untested -- Ben, can you check this?)
> 
> Just a quick ping: is this making its way to Linus (and stable)?  I've
> been running it for five days through (literally, due to monitor bugs)
> thousands of plug/unplug cycles with no ill effects.
This issue has been fixed in nouveau git now, but that fix can't be
pulled into stable/linus as it depends on architectural changes to
nouveau that Linus probably wouldn't accept this late.

I responded to a mail asking that the patches be redone to just fix the
bug *without* removing the "magic numbers" (so, just patch 2/2
essentially), to avoid more unnecessary conflicts with nouveau git.

Ben.

> 
> (Can we *please* get rid of, or at least ratelimit, the
> plugged/unplugged printk?  It's taking over my logs, and I'm almost
> certain that it's not a driver bug.)
> 
> --Andy


