Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2AWJSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 04:18:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53671 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2AWJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 04:18:08 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 23 Jan 2012 11:17:46 +0200
X-Google-Sender-Auth: 86i4__f4WfS81a32ADkxo25uuwg
Message-ID: <CADMYwHxhyExw8jzAVT6PEdfXT-vCSLxg_eGbbqCwRNh0q3Q6eQ@mail.gmail.com>
Subject: Re: Linux 3.3-1 out - merge window closed
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Brian Swetland <swetland@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Jan 20, 2012 at 1:58 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> There are a couple of trees I haven't merged on purpose, and there may
> be a few trees I overlooked by mistake. The "on purpose" ones were
> things that looked unfamiliar and I felt I didn't have the bandwidth
> to check. The "mistake" ones would just be things I missed due to
> being busy.

I guess that the remoteproc/rpmsg tree belongs to the "on purpose" department :)

> So if you felt that your pull request was overlooked by mistake (or
> intentionally, but really not so scary that you think I should have a
> really easy time checking it), you have a couple of days to marshal
> your arguments for why I should pull it after all.

I realize there's a slim chance to get it merged at this point, but I
do think that both remoteproc and rpmsg are not so scary:

* The code is completely self contained, and the only few external
places it changes amount to grabbing a new virtio id (which is
Acked-by Rusty) and some OMAP init platform code (which is Acked-by
Tony). People who aren't explicitly using it won't notice it's there;
even its Kconfig entries get selected automatically when relevant
(i.e. only on OMAP4 at this point) and would never show up otherwise.

* Remoteproc is just a driver. It had to be generic, because there's
very little platform-specific parts in it, and lots of different SoCs
need something like it, but all in all it's a simple driver that loads
a firmware and power up a remote core.

* Rpmsg is, essentially, a simple send/receive API that allows drivers
to communicate with remote services. The real gory details (and wit!)
are actually handled by virtio, which is used as the shared-memory
"wire" protocol with the remote core. Thanks to virtio, rpmsg ended up
very simple and lightweight. It had to be generic, too, because
there's nothing platform-specific in it, and drivers for remote
services could easily end up being used on several different
platforms.

* These frameworks have been discussed in embedded/ARM circles for
quite some time, and numerous maintainers support it, including Arnd
and Grant.

It's a real need for many SoCs, and not a niche hardware support: this
drives, e.g., the camera and video use cases of the Galaxy Nexus
phone. At this point there are several teams, spanning several
vendors, which look into adding support for this (and further
developing it), so merging it will just make collaboration easier.

Hope this all makes sense (and sorry for the sales pitch :).

Thanks,
Ohad.
