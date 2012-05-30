Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2E3U7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:59:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47427 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab2E3U67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <1338410107.2760.544.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com> <1338402812.2760.413.camel@edumazet-glaptop>
 <4FC66D3D.6080509@fusionio.com> <1338404902.2760.451.camel@edumazet-glaptop> <1338410107.2760.544.camel@edumazet-glaptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 May 2012 13:58:37 -0700
X-Google-Sender-Auth: IpwezROSVoMz4sSkuRcBQG-YUH4
Message-ID: <CA+55aFysiKSfawC3my5jP11ChNdkvuz2TjJstFhM+6CSmnbpzg@mail.gmail.com>
Subject: Re: [GIT PULL] Block driver bits for 3.5
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, can you verify that reverting that one commit on top of current
-git fixes things for you?

I'm a bit surprised that it would be that simple commit that actually
just *removes* a mutex use that causes it, so the bisect result looks
a bit fishy. Maybe it's a race that doesn't always cause the lockup at
boot, in which case it might have bisected to the wrong thing..

But if reverting that commit from top-of-tree fixes it, that's pretty
unambiguous.

                    Linus

On Wed, May 30, 2012 at 1:35 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> commit d3ca8b64b97ef4dc54d7bb0b88bbc01a1fca8cb9
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Tue May 29 13:45:01 2012 +0100
>
>    pty: Fix lock inversion
>
>    The ptmx_open path takes the tty and devpts locks in the wrong order
>    because tty_init_dev locks and returns a locked tty.  As far as I can
>    tell this is actually safe anyway because the tty being returned is new
>    so nobody can get a reference to lock it at this point.
>
>    However we don't even need the devpts lock at this point, it's only held
>    as a byproduct of the way the locks were pushe down.
>
>    Signed-off-by: Alan Cox <alan@linux.intel.com>
>    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
>
>
