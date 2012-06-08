Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2FHWXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:23:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39822 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab2FHWXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <1339193608_596134@CP5-2952>
References: <alpine.DEB.2.00.1206080952010.15272@skynet.skynet.ie>
 <CA+55aFyASr5Jfok7vVKXg9=n_pBGyjLZf3MmRik90y8qXRNo3g@mail.gmail.com> <1339193608_596134@CP5-2952>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Jun 2012 15:23:15 -0700
X-Google-Sender-Auth: C29cD-oIk0irDspwJMSr28-N4-o
Message-ID: <CA+55aFxQn_KJcHztPyUptOb=s-+n5-4mDs+dGL1XiN4QbAv2mg@mail.gmail.com>
Subject: Re: [git pull] drm intel + exynos fixes
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 3:12 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
>           So it falls back to
> load-detection, which in your case it cannot do since all the available
> pipes are assigned and so it just reports the VGA connection as unknown.

Btw, it's a singularly stupid decision to say "Ok, I *know* I have a
monitor on output X, and I have no clue what-so-ever what I have on
output Y, and no indication there is anything even there, so let me
just degrade the output on output Y just in case".

Which is basically what you are arguing for. In addition to the
idiotic of argument that "ok, it used to work right, but we broke it
on *purpose*, really".

I'd suggest that if you see no other connectors at all, *then* you
might say "ok, let's assume that we have a VGA monitor behind a broken
KVM switch". At that point, at least that assumption doesn't make
things worse for anything else that you know is there.

And if people have truly undetectable VGA hardware in addition to
another (detectable) output, I would suggest that you tell them to
force it with xrandr. Again, there's no way in hell I will accept the
idiotic argument that my old working single-monitor setup should be
broken because the i915 driver decided that I *might* have a second
monitor on VGA despite everything else saying that is not the case.

                    Linus
