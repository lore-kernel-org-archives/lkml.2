Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1EYTNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:13:11 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:39423 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1EYTNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:13:10 -0400
Date: Wed, 25 May 2011 21:12:53 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Fabio Erculiani <lxnay@sabayon.org>
Cc: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbmem: fix race condition between
 register_framebuffer() and fb_open()
Message-ID: <20110525211253.4985ee79@neptune.home>
In-Reply-To: <BANLkTimtYvcN8kj+jnaKHNGmN36YvMt7Rg@mail.gmail.com>
References: <1306266871-12464-1-git-send-email-lxnay@sabayon.org>
	<20110524224545.08c53b1d@neptune.home>
	<20110525181917.12cf97b8@neptune.home>
	<BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
	<20110525204648.58983270@neptune.home>
	<BANLkTi=207-bVi3pnOWk7zG61u4=YU4GFg@mail.gmail.com>
	<20110525205707.12abc68c@neptune.home>
	<BANLkTimtYvcN8kj+jnaKHNGmN36YvMt7Rg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 Fabio Erculiani <lxnay@sabayon.org> wrote:
> On Wed, May 25, 2011 at 8:57 PM, Bruno Prémont wrote:
> > On Wed, 25 May 2011 Fabio Erculiani <lxnay@sabayon.org> wrote:
> >> On Wed, May 25, 2011 at 8:46 PM, Bruno Prémont wrote:
> >> > On Wed, 25 May 2011 Fabio Erculiani <lxnay@sabayon.org> wrote:
> >> >> I'm not a fbdev expert. So I leave the real fix to real men ( ;-) ).
> >> >> It is causing deadlock during boot, so I would consider it quite critical.
> >> >> Users using any fb driver will get into troubles.
> >> >> The workaround is to boot with vga=normal.
> >> >
> >> > What is your system doing during boot? I've never seen it here but maybe
> >> > my boot sequence is too simple.
> >>
> >> I'm using vesafb and vga=791. It is quite simple to reproduce.
> >> Also see: http://bugs.gentoo.org/show_bug.cgi?id=368109
> >
> > Looks like gentoo kernel, might be splash is related to the hang
> 
> Then, if you say so, it must be the fbsplash patch for sure, I keep
> forgetting of that :-/

I've had a look at the bug report which points at fbcon_decore
patch.

Looking into that patch confirms my impression:
  fbcon_decor calls a userspace helper at the time fbcon takes over
  console and that userspace helper then tries to open fb device
  with the aim of calling some IOCTLs.

Probably changing fbcon_decor to just call the userspace helper in
non-blocking mode (or having userspace helper "fork and detach") would
avoid the deadlock as well.
Though fbcon_decor seems to rely on helper's return code...

What is the matching piece on userspace side so I can look at it as well?

Bruno
