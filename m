Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1BPUF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:05:27 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:52627 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753757Ab1BPUFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:05:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=V1aUUdZVtuClbQooarp8t89CMSBG/GEMQDTgxu6b6s9KMkmRci99HUzs4UpfrcxIN3zhY6cuvF72/RzB/Hdrd3o1i0JI+G56LGBrhDZ/4GvIyVm7HsbvD4KRNtZMqRhL;
Date: Wed, 16 Feb 2011 12:05:18 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
Message-ID: <20110216120518.66dcedff@jbarnes-desktop>
In-Reply-To: <AANLkTik+t1A1omh6fh6o_U6mnk6Y3=K+OjnozSmr44Hv@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	<20110216192658.GA7225@blimp.localdomain>
	<AANLkTinuF0na0zLOFOjFWapoNNXCUay88BdrxH0-_ybM@mail.gmail.com>
	<20110216115406.631ada72@jbarnes-desktop>
	<AANLkTik+t1A1omh6fh6o_U6mnk6Y3=K+OjnozSmr44Hv@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 20:59:35 +0100
Alex Riesen <raa.lkml@gmail.com> wrote:

> On Wed, Feb 16, 2011 at 20:54, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Wed, 16 Feb 2011 20:46:45 +0100
> > Alex Riesen <raa.lkml@gmail.com> wrote:
> >> > The backlight level on this Dell XPS M1330 reduces every time I reopen
> >> > the lid, and BIOS does not seem to know anything about that (the
> >> > keyboard shortcuts to set backlight brightness cause it to jump to the
> >> > level next to the one set before closing the lid).
> >>
> >> It is this bug, I believe:
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=25072
> >>
> >> I somehow missed it at first, and only noticed after sending the patch.
> >
> > There's also this patch: https://patchwork.kernel.org/patch/499221/.
> > It got things working on my E6510 again at least.
> 
> I don't think it is related. I don't have problems switching
> the outputs (frankly, didn't try) and I do have problems
> restoring backlight, very similar to what I had earlier in
> 2.6.37.

Right, but it affects the registration of the backlight and ACPI video
interface as well, so can affect backlight restore on resume.  In my
case, without the above patch my backlight wouldn't be restored on
resume, so I'd have to manually echo a value
into /sys/class/backlight/<foo> to get my display back.

-- 
Jesse Barnes, Intel Open Source Technology Center
