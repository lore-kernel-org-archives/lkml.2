Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1AKHEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 02:04:41 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45110 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1AKHEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 02:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=txfHMbG9fppmIOk0yntoopvIfBmX4MXJesD0Mh9DKP1qvGXVflWuzYXMV4WjnImFcX
         uPFBcDK34+N6lWAtCSYm9c1sE/ytCpmGnfJWSvwS5Tk/N/YlfGlMOBAsUlSDtFc+9LLj
         3zf/yOv22HHPp5BnJtOaLqakAD1gwqoZBKX4U=
MIME-Version: 1.0
In-Reply-To: <AANLkTikYzz0Rs-vdX5uFDm6CpXDOx62cUYfbqEAXSame@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
	<AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
	<0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com>
	<AANLkTikYzz0Rs-vdX5uFDm6CpXDOx62cUYfbqEAXSame@mail.gmail.com>
Date: Tue, 11 Jan 2011 17:04:33 +1000
Message-ID: <AANLkTi=L4f8KHes-=aU4Vctr7G8n8qWLh18vR7YM5TE+@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 4:28 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Jan 11, 2011 at 4:06 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> "Dave Airlie" <airlied@gmail.com> wrote:
>>
>>>On Tue, Jan 11, 2011 at 2:16 PM, Linus Torvalds
>>><torvalds@linux-foundation.org> wrote:
>>>> On Mon, Jan 10, 2011 at 2:59 PM, Dave Airlie <airlied@linux.ie>
>>>wrote:
>>>>> Highlights:
>>>>> core/drivers: add support for high precision vblank timestamps
>>>>> radeon: pageflipping support, Gen2 PCIE support
>>>>> nouveau: reworked VRAM and VM support
>>>>> intel: better ILK/SNB powersaving support, Full GTT support
>>>>
>>>> Lowlights: it's broken.
>>>>
>>>> I get millions of messages like:
>>>>
>>>>  ...
>>>>  [ 8482.000414] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
>>>> timer elapsed... render ring idle [waiting on 30938, at 30938],
>>>missed
>>>> IRQ?
>>>>  [ 8485.918124] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
>>>> timer elapsed... render ring idle [waiting on 31068, at 31068],
>>>missed
>>>> IRQ?
>>>>  [ 8487.926963] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
>>>> timer elapsed... render ring idle [waiting on 31129, at 31129],
>>>missed
>>>> IRQ?
>>>>  ...
>>>>
>>>> and everything is very choppy. I assume it's the power saving thing
>>>> that broke again, but that's just a total random guess, I have
>>>nothing
>>>> to actually back that up with.
>>>>
>>>> It worked fine after boot, but those problems began at 8287.139375
>>>> (about two hours after boot - it may have coincided with screen
>>>saver,
>>>> but who knows?)  and have been happening constantly since. The
>>>machine
>>>> is not really usable, I'm writing this with annoying 2-second pauses
>>>> every once in a while.
>>>
>>>Okay I'll try and reproduce and curse Chris and Jesse, does booting
>>>with
>>>i915.powersave=0 help any?
>>>
>>>Dave.
>>
>> Arg.  It's been ok on my ILK systems, but Chris has found some issues with out watermarking code iirc; apparently we're underflowing the display FIFO, causing all sorts of trouble.  If it works before the pull of Dave's tree, can you bisect?
>>
>
> I think he'd fixed them in the tree I pulled locally to test, I'm
> guessing this might be that we are running the Fedora userspace driver
> and you guys are all on master or something, which would mean some ABI
> guarantee got busted.
>
> I'm going to try a local test upgrade to 2.14.0 just to see.

Okay that didn't help, dead in similar times, evince with a few flood
maps from Brisbane seem to be a good trigger.

I'm not sure I'll be in a good place for bisection, need laptop to
keep track of disaster.

Dave.
