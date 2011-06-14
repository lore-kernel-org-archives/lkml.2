Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1FNSQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:16:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab1FNSQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTiko+2AM8dq8jP5xjbTcCM63hBAK=A@mail.gmail.com>
References: <BANLkTiko+2AM8dq8jP5xjbTcCM63hBAK=A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Jun 2011 11:15:53 -0700
Message-ID: <BANLkTimny9nzr23TufH1kMcsk57M3NXuaA@mail.gmail.com>
Subject: Re: Possible deadlock when suspending framebuffer
To: Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Francis Moreau <francis.moro@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul, fbdev people.. Comments? This was sent to me and lkml, the right
people probably didn't see it.

I doubt it's a big problem in practice, but..

                      Linus

On Tue, Jun 14, 2011 at 6:10 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> I noticed that a possible deadlock can happen when the current frame
> buffering is being suspended and a new frambuffer device is being
> registred at the same time.
>
> When suspending the current frambuffer by doing : echo 1
>>/sys/class/graphics/fb0/state, the kernel actually takes the
> following locks in that order: console_lock, lock_fb_info (see
> store_fbstate()).
>
> However when a new framebuffer is coming in, the lock sequence is:
> lock_fb_info (taken by do_remove_conflicting_framebuffer()),
> console_lock() (taken by unbind_console).
>
> I don't know how this should be fixed though...
>
> Thanks
> --
> Francis
>
