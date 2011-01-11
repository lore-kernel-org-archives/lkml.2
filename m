Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1AKEsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 23:48:46 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44617 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab1AKEsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 23:48:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KWUy2LPnL9bSlD7IqfqQexw7mR2x2Wwd6J9i4EwfJ8oCZYgctscdi4xp7h8LA89+H9
         yOWjvfudih6BCQzujdLTE49O5waUFYg3G1CPs3hT6TM2lxA33Z9ZKGVpQHvdCoDryuvK
         O3Myx8yBKFyFGuCnXSEO2rIGhtKVAXEFTFHg4=
MIME-Version: 1.0
In-Reply-To: <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
Date: Tue, 11 Jan 2011 14:48:38 +1000
Message-ID: <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 2:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 10, 2011 at 2:59 PM, Dave Airlie <airlied@linux.ie> wrote:
>> Highlights:
>> core/drivers: add support for high precision vblank timestamps
>> radeon: pageflipping support, Gen2 PCIE support
>> nouveau: reworked VRAM and VM support
>> intel: better ILK/SNB powersaving support, Full GTT support
>
> Lowlights: it's broken.
>
> I get millions of messages like:
>
>  ...
>  [ 8482.000414] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
> timer elapsed... render ring idle [waiting on 30938, at 30938], missed
> IRQ?
>  [ 8485.918124] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
> timer elapsed... render ring idle [waiting on 31068, at 31068], missed
> IRQ?
>  [ 8487.926963] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
> timer elapsed... render ring idle [waiting on 31129, at 31129], missed
> IRQ?
>  ...
>
> and everything is very choppy. I assume it's the power saving thing
> that broke again, but that's just a total random guess, I have nothing
> to actually back that up with.
>
> It worked fine after boot, but those problems began at 8287.139375
> (about two hours after boot - it may have coincided with screen saver,
> but who knows?)  and have been happening constantly since. The machine
> is not really usable, I'm writing this with annoying 2-second pauses
> every once in a while.

Okay I'll try and reproduce and curse Chris and Jesse, does booting with
i915.powersave=0 help any?

Dave.
