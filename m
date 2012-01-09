Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab2AIWHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:07:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42944 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2AIWHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:07:39 -0500
MIME-Version: 1.0
In-Reply-To: <4F0B5808.2010900@cfl.rr.com>
References: <4F0B5808.2010900@cfl.rr.com>
Date: Mon, 9 Jan 2012 23:07:37 +0100
X-Google-Sender-Auth: _JmSsub-78_W4Xrljp-zqm6yzBQ
Message-ID: <CAMuHMdUgScMhtoXonKeJmN1+jJQt_JT0V6Tk--yB-Z8q49rmHg@mail.gmail.com>
Subject: Re: Multiple consoles
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 22:11, Phillip Susi <psusi@cfl.rr.com> wrote:
> I was considering some questions I read about setting up a multi-seat system
> where you have two separate sets of displays, keyboards, mice, and X
> servers.  The problem someone noticed is that if you run the second X server
> on tty8, then you have to switch the console to tty8 to activate it, which
> disables the primary X server.
>
> It occurred to me that there ought to be an entirely separate set of virtual
> consoles bound to the second seat, and the second X server ought to run on
> one of those vcs.  Or of course, you could choose to log into the console
> and not bother with X.
>
> Looking at drivers/tty/vt/vt.c, it appears that it was written assuming that
> there is just one linux console.  It appears to use global variables for
> keeping track of which vc is active, etc, rather than creating one or more
> console devices, and store the vc multiplexing information in those devices.
>  So to fix this, vt.c and keyboard.c would need significantly refactored to
> remove the global variables and create a console device to bind vcs,
> keyboards, and displays to, and then you could create a second one if you
> wanted.
>
> Does this make sense or am I missing something?

The linux-console project tried to fix this (CC James added).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
