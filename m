Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab1BXX3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:29:53 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:36733 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab1BXX3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:29:52 -0500
Message-ID: <1cced1eb38110129d097e1c8b6857d81.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTimLb4=04vOU7_SrtKpWQvFmDfibHGGsC+CFxwCW@mail.gmail.com>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
    <AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
    <0d30dc$l7ehaa@orsmga001.jf.intel.com>
    <AANLkTi=DXg=ighnPi4FYA29=qegE=c_PtCVWzOymYtmQ@mail.gmail.com>
    <b5f94200cffe31ff8cbe38d2bd2e35a7.squirrel@webmail.greenhost.nl>
    <AANLkTimLb4=04vOU7_SrtKpWQvFmDfibHGGsC+CFxwCW@mail.gmail.com>
Date: Fri, 25 Feb 2011 00:29:34 +0100 (CET)
Subject: Re: [git pull] drm fixes
From: "Indan Zupancic" <indan@nul.nu>
To: "Alex Riesen" <raa.lkml@gmail.com>
Cc: "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Dave Airlie" <airlied@linux.ie>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, "Daniel Vetter" <daniel@ffwll.ch>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 353bb18b0f14186cd389c275975c39f5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 24, 2011 20:04, Alex Riesen wrote:
> On Thu, Feb 24, 2011 at 10:18, Indan Zupancic <indan@nul.nu> wrote:
>>>>
>>>> As it turns out this is a bug in the userspace components of the stack for
>>>> gen2 hardware, with lax kernel side enforcement. Daniel has a fix for both.
>>>
>>> Chris, could you point us at the patch? I ask because Daniel left a
>>> comment in bug discussion that we should ignore some patch from him,
>>> and there was no mention of anything else.
>>>
>>> I'll gladly test a better fix.
>>
>> See:
>>
>> http://lists.freedesktop.org/archives/dri-devel/2011-February/008658.html
>
> This is precisely the link on which Daniel commented:
[...]
> And yes, it does not help at all to fix the corruption in the ticket.

Because there are two (or three) corruption problems! One is fixed by
Daniels's patch, the other isn't fixed yet AFAIC.

You're grumbling that I'm giving you information about the fix for one
problem, the one Chris was talking about and you replied to, while you're
interested in the other one (or both).

>> https://lkml.org/lkml/2011/2/23/34
>
> This is just the discussion about the problem described in the ticket.
> It does not even mention the patch from the previous link, BTW.
> It does have the patch which returns -EINVAL for I915_PARAM_HAS_RELAXED_FENCING,
> though.
>
> So, AFAICS, at the moment there is no better patch than this:
>
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 17bd766..8f8a6a3 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -764,7 +764,7 @@ static int i915_getparam(struct drm_device *dev, void *data,
>  		break;
>  	case I915_PARAM_HAS_RELAXED_FENCING:
>  		value = 1;
> -		break;
> +		return -EINVAL;
>  	case I915_PARAM_HAS_COHERENT_RINGS:
>  		value = 1;
>  		break;

Read those above links again! Daniel's patch fixes that one corruption, the
above snippet has the same effect and works around the same bug, but neither
do fix that other corruption mentioned in the ticket.

Greetings,

Indan


