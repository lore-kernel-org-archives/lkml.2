Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0LWRtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:49:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545Ab0LWRtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:49:07 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTin_BLuv+T5jg6nM2KxaQjpR+T0JZACR480t5N0=@mail.gmail.com>
References: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie>
 <s5hei99vkqj.wl%tiwai@suse.de> <c6d829$pujifv@fmsmga001.fm.intel.com>
 <AANLkTik4N5Caw2f4nNFgYXDjxwCMvkyLGyTrkz+vDfXS@mail.gmail.com> <AANLkTin_BLuv+T5jg6nM2KxaQjpR+T0JZACR480t5N0=@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Dec 2010 09:48:17 -0800
Message-ID: <AANLkTikwQNim-hcTm7Wn7pzUnVkfG6=9JCKNMRyM0rmm@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Takashi Iwai <tiwai@suse.de>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 1:32 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
> On Thu, Dec 23, 2010 at 04:54, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Why does that code need to figure out some LVDS clock from the BIOS?
>> Why can't the code look at the actual hardware state or similar, since
>> presumably the screen is on after boot. THAT we can rely on, since a
>> BIOS that doesn't initialize LVDS is not going to ever ship even as
>> pre-release.
>
> What if the system booted with it's display turned off? Like a closed
> laptop lid or disconnected monitor?

So then we might have to guess and even use the BIOS state for guessing.

But what's so hard to understand about that word "guess"? That really
is what happens every single time you use some BIOS table. It's not
"look up". It's not "get the right data". It very much is all about
"guessing". The BIOS tables are invariably buggy, and have likely only
ever been tested with one particular version of Windows.

And that's _especially_ true of something like VBIOS tables. They
haven't been tested even with windows, they have only been tested with
the particular graphics driver that the vendor shipped with that
machine. It's quite possible - even likely - that the graphics driver
hard-codes something.

So think about it - if we boot with the laptop open, you have two
choices: "ask the hardware for real working state" or "guess by
probing random state from the BIOS that may or may not actually ever
be used that way by anything".

Which choice would you pick?

And if that means that some laptops have to be booted with the lid
open, that really isn't a problem.

And yes, I do realize that VGA traditionally has had lots of hardware
state that is write-only and cannot be read back. It's possible that
this case is one of those. I dunno. I hope not.

(Side note: resume is different from boot. You should test that resume
works with the lid closed, because resume state is not at all
guaranteed to be sane at all, lid or no lid. But the way to fix that
is NOT to ask the BIOS, it's to remember the state from the original
boot from before the suspend).

                                  Linus
