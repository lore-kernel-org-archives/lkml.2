Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0GRRAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 13:00:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756685Ab0GRRAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 13:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <4C430F52.7040400@superonline.com>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
	<1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
	<89k77n$ms73l9@fmsmga001.fm.intel.com>
	<alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
	<AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
	<89khjo$fr177d@orsmga002.jf.intel.com>
	<AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com>
	<AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
	<4C2D180C.5050805@superonline.com>
	<AANLkTiklUBmNYs3710WftVX0Z3QihxFtDlK7tPlHZh8H@mail.gmail.com>
	<AANLkTilOWu6ZwWjwPfHvNXDhyjb6n4N5KV1rUx6byJmq@mail.gmail.com>
	<AANLkTilfkCBfZtRQlybQ721PSF4lSlqeOKL3rYnEz2G1@mail.gmail.com>
	<AANLkTikpw42jE5Eh0EkXuRh70mb9x3njX6R4JNshawe5@mail.gmail.com>
	<4C41FD6E.9090603@superonline.com>
	<AANLkTikqSwnLqJXPYGjMP0NS8TJ4D2uOBLDipoV89Qwc@mail.gmail.com>
	<4C430F52.7040400@superonline.com>
Date: Sun, 18 Jul 2010 09:59:28 -0700
Message-ID: <AANLkTin8sbiCQCOUatWAadfLBKuOXUQHKAH1Bs0aTztp@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Cc: Dave Airlie <airlied@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        earny@net4u.de, Roman Jarosz <kedgedev@gmail.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        jcnengel@googlemail.com, "A. Boulan" <arnaud.boulan@libertysurf.fr>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
        michael@reinelt.co.at, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 18, 2010 at 7:27 AM, M. Vefa Bicakci <bicave@superonline.com> wrote:
>
> After hours of testing I came up with the following result: We need
> to have the __GFP_RECLAIMABLE flag in addition to GFP_HIGHUSER.

Thanks for the extensive testing, and I'm committing the one-liner to
add it, and cc'ing it to stable. I'm pretty certain that there is
something overly fragile in the i915 driver that this flag makes so
much of a difference, but at the same time I'm actually happy that
it's that reclaimable flag, because at least that one was always the
"conceptually makes sense" one.

So I suspected it would be some low-memory issue and the flag that
woudl turn out to matter would be the NOMEMALLOC one, but I'm happy to
have been wrong. Adding __GFP_RECLAIMABLE is sane, although I really
would like to understand why the i915 driver apparently cares so
deeply about the allocation/freeing patterns.

But whatever. Thanks again for being such a thorough tester,

                        Linus
