Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1CWOjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:39:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36804 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1CWOjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:39:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iqYxJh70cUZdm4428eEHHWYY69D8OQ/YSFl4bI93RIzw8JYHM1e8V/kQEXf2vbwHXV
         7ePl5Gt1clOiAZRP0VYqbZBYPvLTimjT3mbjHKB8sgqvD6hZuydf8rnUgeAaAluW8+WT
         VNfBl+Z1xQWth9kj6guaYbzIEGZp3GJmP/Nag=
MIME-Version: 1.0
In-Reply-To: <AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
References: <alpine.DEB.2.00.1103170403160.3429@skynet.skynet.ie>
	<AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
Date: Wed, 23 Mar 2011 15:22:55 +0100
Message-ID: <AANLkTim5qv63qiZ6uazvQUjtCtKrzYNGDVr1aESaAkCj@mail.gmail.com>
Subject: Re: [git pull] drm next tree
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 3:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So I had  hoped - yes, very naïve of me, I know - that this merge
> window would be different.
>
> But it's not.
>
> On Wed, Mar 16, 2011 at 9:09 PM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> i915: big 855 fix, lots of output setup refactoring, lots of misc fixes.
>
> .. and apparently a lot of breakage too. My crappy laptop that I abuse
> for travel is - once more - broken by the updates. I cannot suspend
> and resume, because every resume seems to fail.
>
> One of the more useful failures was:
>
> [   61.656055] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> elapsed... GPU hung
> [   61.656079] [drm] capturing error event; look for more information
> in /debug/dri/0/i915_error_state
> [   61.664387] [drm:i915_wait_request] *ERROR* i915_wait_request
> returns -11 (awaiting 2 at 0, next 3)
>
> and I'm attaching the error_state file from that particular case here.
> In other cases it seems to just hang entirely.
>
> Keith/Jesse/Chris - I don't know that it's i915, and it will take
> forever to bisect (I'll try). But it does seem pretty likely.

Just in case - is it possible to have that commit in diff format ?

Asking as 2.6.38-git2 is the latest kernel where my Latitude E6400
 is displaying X at 1440x900, -git3 through -git6 do not compile and
 -git7 and onwards (up at least to -git11) display 1024x768 instead.

If I run xrandr --fb 1440x900 --output LVDS1 --mode 1440x900
 once in X, then I get 1440x900 display, but then:

  - the wallpaper's original 1024x768 image stays (the rest of the
     display area is filled with the part of image that should be there
     correctly at 1440x900)
  - if I run mplayer and ask it to go fullscreen, it does 1024x768

lspci (from 2.6.38-git2) says:

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA
controller])
	Subsystem: Dell Device 0233
	Flags: bus master, fast devsel, latency 0, IRQ 46
	Memory at f6c00000 (64-bit, non-prefetchable) [size=4M]
	Memory at e0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at ef98 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 3
	Kernel driver in use: i915
	Kernel modules: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
Integrated Graphics Controller (rev 07)
	Subsystem: Dell Device 0233
	Flags: bus master, fast devsel, latency 0
	Memory at f6b00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3


thanks,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
