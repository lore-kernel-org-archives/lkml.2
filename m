Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1KHOxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:53:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65166 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab1KHOxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:53:39 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
Date: Tue, 8 Nov 2011 15:53:38 +0100
Message-ID: <CAKWSe6Dr7G3TgeMiff=hrT1bMc+StnXdtW0MEmQcuA5yFOWJYw@mail.gmail.com>
Subject: Re: Linux 3.2-rc1
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 3:10 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So it's been two weeks since 3.1, and you know how it works by now.
>
> I have to say, this wasn't my favorite merge window ever. I really
> wanted to take only things that had been in -next, but verifying it
> was fairly painful, since a lot of the trees had been rebased, and the
> ones that hadn't been rebased often had some extra patches that still
> showed up when I did my "git log linux-next..FETCH_HEAD" thing.
>
> On the whole, most of it was all good, and I didn't really end up
> complaining to people. I'm pretty sure that there were trees I
> shouldn't have let through, but the majority really had been in -next.
>
> The other point of irritation was that there really was a lot of stuff
> that came in yesterday and basically treated the merge window as some
> kind of high-tech limbo dance. If it hadn't been for a few trees I
> wanted to pull, I had actually planned to do the -rc1 release Sunday
> afternoon instead, just to cut those annoying last-minute pull
> requests off.
>
> And some trees didn't get pulled. You know who you are, and you can
> try to appeal to my softer side if you think it was unfair. Of course,
> if you *do* find my softer side, please tell my wife and kids too,
> they'll be thrilled.
>
> But the main reason some trees didn't get pulled was that they
> generated long flame-wars, and I just felt like I really didn't need
> the aggravation this time around, especially as I knew I had plenty
> other trees to pull.
>
> What *did* get pulled? A lot. The diffstat is huge, and is full of
> renames. The network drivers got re-organized, which is a big chunk of
> the renames, but there are architecture cleanups and re-organizations
> there too (UML and some arm sub-architectures, for example) adding
> their own set of renames. Along with some staging drivers that got
> upgraded to non-staging etc etc.
>
> Which brings me to a question I already asked on G+ - do people really
> need the old-fashioned patches? The -rc1 patch is about 22MB gzip-9'd,
> and part of the reason is that all those renames cause big
> delete/create diffs. We *could* use git rename patches, but then you'd
> have to apply them with "git apply" rather than the legacy "patch"
> executables. But as it is, the patch is almost a third of the size of
> the tar-ball, which makes me wonder if there's even any point to such
> a big patch?
>
> Apart from the re-organization, there is really just a lot of changes
> all over. It's about 75% drivers (and that's without the renames
> counted as big delete/create events - in the traditional diff, more
> than 90% is drivers), 15% arch, and 10% "rest" (mainly fs and net -
> with header file changes showing up in the statistics too).
>
> What doesn't even show up in the stats is the VM changes, although
> those may well be the most noticeable core stuff. It may be fairly
> small, but it's rather more core, and has the potential to affect
> everybody. People have been working on writeback tuning, and the whole
> IO-less dirty balancing. So now foreground writeback should be a thing
> of the past. Let's see how that all works out.
>
> Have fun, give it a good testing. There shouldn't be anything hugely
> scary in there, but there *is* a lot of stuff. The fact that 3.1
> dragged out did mean that this ended up being one of the bigger merge
> windows, but I'm not feeling *too* nervous about it.
>
>                 Linus


Dell laptop support (and I'd suspect other drivers using LED support)
 doesn't build with undefined LED-related functions, as in:

ERROR: "led_classdev_unregister" [drivers/platform/x86/dell-laptop.ko]
undefined!
ERROR: "led_classdev_register" [drivers/platform/x86/dell-laptop.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

It's enough to configure NEW_LEDS (unneeded in 3.1.0) to allow the build to go
 through; maybe NEW_LEDS should be auto-selected in Kconfig by drivers that
 make use of led_classdev_* functions ?

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
