Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0GWBT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 21:19:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48069 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0GWBT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 21:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=weMKQUU6l2dvGFJTTS98BZj5WCfYHbuXSTuuEGsOooy4C2TYeIloFOmee+t554zV88
         zJy5AA69BzSSeRBUmjlBB6TQkyO9J0B7zvHT4CYpUgnEomiCvbsvg0Ft89LnWzv5cdZz
         RsYXtRloJRsKZw/XrpmQNGUYoPOTqZYTAlcYI=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTin1vGdodjhqbckGpVtfScslb7d0KX0h4wPa54Yh@mail.gmail.com>
References: <AANLkTin1vGdodjhqbckGpVtfScslb7d0KX0h4wPa54Yh@mail.gmail.com>
Date: Fri, 23 Jul 2010 02:19:26 +0100
Message-ID: <AANLkTilI3KjFn1Ys09fC_ty0V2c9k8GndH0wZAwGaCaI@mail.gmail.com>
Subject: Re: 2.6.35-rc[1-5] + Radeon-kms: 3D graphic performance
From: trapDoor <trapdoor6@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had sent the first e-mail too soon by accident. In Gmail interface
the 'Send' and 'Save Now' buttons are dangerously close to each other,
far too close I'd say ..
So, what is missing there:
- a brief description of the regression (it's in the previous thread)
- when did it start: 2.6.35-rc1
- how I tested it
- what I think is causing it

I will just refer to the last point now: I think the regression is
caused by the vblank stuff you mentioned in previous thread. And here
is the pattern I've found during testing:
Since the vblank patches have been committed (2.6.35-rc1) the glxgears
app started to show the accurate number of fps, corresponding to
vrefresh, and that's of course good. But in the same time when
glxgears behaves properly, the performance in Armagetron Advanced
decreases. During the unfinished bisect I had two 'good' and two 'bad'
kernels and in each case the bad kernel had the vblank commit(s)
applied (as far as I would know - just by looking at number of fps in
glxgears) and performance in AA was worse than in the 'good' kernels
without the vblank stuff. I'm not suggesting anything that the vblank
stuff is responsible directly for the regression. I just say what I
noticed. It may be that those patches cause the problem but only in
specific circumstances (e.g. with some other patches).

I could just revert the commit(s) on current git tree or if there will
be any conflicts from some earlier version, and see what happens. I
think It will be (one of) these ?

commit f81f202402640c27b38e1452dcb4d3e447043f48
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed Apr 28 12:13:06 2010 -0400

    radeon: Try harder to ensure we reclock in vblank

    The vblank interrupt on r600 doesn't seem to be especially reliable, so
    perform some sanity checks before the actual reclock.

------
commit 8a56df632e524a1c444c56bb7ce9fe8d94e639e0
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Mar 15 17:09:05 2010 -0400

    drm/radeon/kms/pm: interate across crtcs for vblank


-- 
Regards
trapDoor


>>>>>>>>>>>>>>>>>>>>>>>>>>
On Fri, Jul 23, 2010 at 1:21 AM, trapDoor <trapdoor6@gmail.com> wrote:
> Hi Alex,
> This is with regard to thread 'Blank (disconnected) screen during boot
> with latest 2.6.35-rcX kernels'.
>
> You asked me in your last e-mail if I could do a bisect to find out
> what caused a regression I mentioned about - in 3D graphic performance
> in kernels 2.6.35-rc + radeoon-kms. I started the bisect but
> unfortunately I haven't finished due to some problems I came across
> and I'm not sure if I can continue it. I'm pointing below how the
> bisect went and - if you'd like to take a look - at the last point I
> explained why I stopped.
>
> I did notice some pattern during this unfinished bisect though. And I
> think it may narrow down the regression to its source.
>
>
>
> ------
> 1. boot from 2.6.35-rc5-git4:
> git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> linus-git
> cd linux-git
> git bisect start
>
> # marking kernel 2.6.35-rc1 as bad
> git bisect bad 67a3e12b05e055c0415c556a315a3d3eb637e29e
>
> # marking kernel 2.6.34 as good
> git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
> Bisecting: 4139 revisions left to test after this (roughly 12 steps)
> [f8965467f366fd18f01feafb5db10512d7b4422c] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
>
> ------
> 2. boot from 2.6.34-04401-gf896546 [f8965467f366fd18f01feafb5db10512d7b4422c]
> git bisect good
> Bisecting: 1978 revisions left to test after this (roughly 11 steps)
> [d79df0b1eda0099a22cbcece01ce5e7d222450de] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
>
> ------
> 3. boot from 2.6.34-06562-gd79df0b [d79df0b1eda0099a22cbcece01ce5e7d222450de]
> git bisect bad
> Bisecting: 1102 revisions left to test after this (roughly 10 steps)
> [ac3ee84c604502240122c47b52f0542ec8774f15] Merge branch
> 'dbg-early-merge' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb
>
> ------
> 4. boot from 2.6.34-05459-gac3ee84 [ac3ee84c604502240122c47b52f0542ec8774f15]
> git bisect good
> Bisecting: 551 revisions left to test after this (roughly 9 steps)
> [7a6cb0d5497418599d2125b670926b75e673861c] Staging: Use kcalloc or kzalloc
>
> ------
> 5. boot from 2.6.34-rc6-00551-g7a6cb0d
> [7a6cb0d5497418599d2125b670926b75e673861c]
> git bisect good
> Bisecting: 239 revisions left to test after this (roughly 8 steps)
> [79c4581262e225a7c96d88b632b05ab3b5e9a52c] Merge branch 'next' of
> git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
>
> ------
> 6. boot from 2.6.34-05771-g79c4581 [79c4581262e225a7c96d88b632b05ab3b5e9a52c]
> git bisect bad
> Bisecting: 155 revisions left to test after this (roughly 7 steps)
> [5876dd249e8e47c730cac090bf6edd88e5f04327] radeon: Unmap vram pages
> when reclocking
>
> ------
> 7. boot from 2.6.34-rc5-00156-g5876dd2
> [5876dd249e8e47c730cac090bf6edd88e5f04327]
> At this point I get stuck as I'm unable to perform the tests:
>
> -- Gnome fails to start, system freezes right after logging in
>
> -- KDE starts but it's almost unusable - very poor 2D performance and
> 3D seems to not work at all:
> desktop lost support for transparency/translucency
> glxgears: just a black window appears with no gears; in the output
> console it shows this:
> XIO:  fatal IO error 11 (Resource temporarily unavailable) on X server ":0.0"
>      after 36 requests (36 known processed) with 0 events remaining.
> Armagetron Advanced obviously doesn't work either - as above, just a
> black window comes up
>
> -- under minimal X environment (xterm) glxgears and Armagetron
> Advanced behave the same way as above
>
> Now I don't know if I can/how to continue this bisect. Clearly
> 2.6.34-rc5-00156-g5876dd2 is affected in the area I was testing. But
> differently and to the degree where I'm actually unable to test what I
> was testing. Also these issues may be not related to the original
> regression. They may be caused by different commit(s).
>
> To sum up: I can't specify whether kernel 2.6.34-rc5-00156-g5876dd2 is
> good or bad, in order to continue this bisect.
>
> Maybe I should start another bisect to solve the problem caused by
> this kernel, revert/apply appropriate patch(es) and then continue with
> the original bisect ? And then, with the next kernel, I may be able to
> carry on or I may be not and have to repeat what I did as a result of
> the 2nd bisect. Or I may bump into some other problems and have to
> start 3rd bisect ... I imagine that people can get into such traps but
> there must be some ways to solve it quicker and not get into endless
> bisect loop. Of course I'm not saying all this to show that I'm
> getting discouraged. Not at all - the more I learn about git the more
> I like it. It's magic, some people say - and I think they may be
> right.
>
>
> --
> Regards
> trapDoor
>
