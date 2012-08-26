Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2HZTNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 15:13:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54728 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2HZTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 15:13:51 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120826184249.GC5194@phenom.ffwll.local>
References: <1345846584-5910-1-git-send-email-sedat.dilek@gmail.com>
	<1345846584-5910-3-git-send-email-sedat.dilek@gmail.com>
	<20120826184249.GC5194@phenom.ffwll.local>
Date: Sun, 26 Aug 2012 21:13:49 +0200
Message-ID: <CA+icZUWpT3of7kOb-mqSMth2uu9TAMkX3gum0qNfoEyFwRvCGg@mail.gmail.com>
Subject: Re: [PATCH drm-next 3/3] drm/i915/contexts: Fixup merge with commit b6c7488df68a
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Sedat Dilek <sedat.dilek@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 8:42 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sat, Aug 25, 2012 at 12:16:24AM +0200, Sedat Dilek wrote:
>> This is a fixup patch for the merge of drm-next into linux-next caused
>> by commit b6c7488df68a ("drm/i915/contexts: fix list corruption").
>>
>> Reported-By: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> This is wrong, switch_context _must_ happen before ring_idle, otherwise
> all hell can break loose on resume.

I followed what's in drm-intel-next not what was in Linus-tree.

- Sedat -

http://cgit.freedesktop.org/~danvet/drm-intel/tree/drivers/gpu/drm/i915/i915_gem.c?h=drm-intel-next#n2432

> -Daniel
>
>> ---
>>  drivers/gpu/drm/i915/i915_gem.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
>> index 4f6841d..e8a5cb2 100644
>> --- a/drivers/gpu/drm/i915/i915_gem.c
>> +++ b/drivers/gpu/drm/i915/i915_gem.c
>> @@ -2273,11 +2273,11 @@ int i915_gpu_idle(struct drm_device *dev)
>>
>>       /* Flush everything onto the inactive list. */
>>       for_each_ring(ring, dev_priv, i) {
>> -             ret = i915_switch_context(ring, NULL, DEFAULT_CONTEXT_ID);
>> +             ret = i915_ring_idle(ring);
>>               if (ret)
>>                       return ret;
>>
>> -             ret = i915_ring_idle(ring);
>> +             ret = i915_switch_context(ring, NULL, DEFAULT_CONTEXT_ID);
>>               if (ret)
>>                       return ret;
>>
>> --
>> 1.7.9.5
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
