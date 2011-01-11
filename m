Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1AKGG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 01:06:27 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:52695 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751035Ab1AKGGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 01:06:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:X-User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:Date:To:CC:Message-ID:X-Identified-User;
	b=APjx8nTuwhvmgkfyyicJe438WRHhsjrN6Kn1VTVjCO76HWA0jhSE/GwoOLPRyXw7n1K/1NT1fRuKQIX518EpFOu76nj5Wzul5THf/mUxZnlY7lWjrJCBGZq9EWURIlm/;
X-User-Agent: K-9 Mail for Android
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com> <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
In-Reply-To: <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [git pull] drm for rc1
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 10 Jan 2011 22:06:29 -0800
To: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Anholt <eric@anholt.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Message-ID: <0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com>
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Dave Airlie" <airlied@gmail.com> wrote:

>On Tue, Jan 11, 2011 at 2:16 PM, Linus Torvalds
><torvalds@linux-foundation.org> wrote:
>> On Mon, Jan 10, 2011 at 2:59 PM, Dave Airlie <airlied@linux.ie>
>wrote:
>>> Highlights:
>>> core/drivers: add support for high precision vblank timestamps
>>> radeon: pageflipping support, Gen2 PCIE support
>>> nouveau: reworked VRAM and VM support
>>> intel: better ILK/SNB powersaving support, Full GTT support
>>
>> Lowlights: it's broken.
>>
>> I get millions of messages like:
>>
>>  ...
>>  [ 8482.000414] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
>> timer elapsed... render ring idle [waiting on 30938, at 30938],
>missed
>> IRQ?
>>  [ 8485.918124] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
>> timer elapsed... render ring idle [waiting on 31068, at 31068],
>missed
>> IRQ?
>>  [ 8487.926963] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
>> timer elapsed... render ring idle [waiting on 31129, at 31129],
>missed
>> IRQ?
>>  ...
>>
>> and everything is very choppy. I assume it's the power saving thing
>> that broke again, but that's just a total random guess, I have
>nothing
>> to actually back that up with.
>>
>> It worked fine after boot, but those problems began at 8287.139375
>> (about two hours after boot - it may have coincided with screen
>saver,
>> but who knows?)  and have been happening constantly since. The
>machine
>> is not really usable, I'm writing this with annoying 2-second pauses
>> every once in a while.
>
>Okay I'll try and reproduce and curse Chris and Jesse, does booting
>with
>i915.powersave=0 help any?
>
>Dave.

Arg.  It's been ok on my ILK systems, but Chris has found some issues with out watermarking code iirc; apparently we're underflowing the display FIFO, causing all sorts of trouble.  If it works before the pull of Dave's tree, can you bisect?

Thanks,
--
Jesse Barnes, Intel Open Source Technology Center
