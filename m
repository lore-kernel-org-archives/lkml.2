Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1KZQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 11:29:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50727 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1KZQ3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 11:29:13 -0500
MIME-Version: 1.0
In-Reply-To: <e0d58a$2cdsbh@orsmga002.jf.intel.com>
References: <1321382968.8791.4.camel@localhost.localdomain>
	<20111121162306.GB3807@phenom.ffwll.local>
	<868vn9ieey.fsf@sumi.keithp.com>
	<CADZ9YHgwcjz=mkMxWxV1pT7fH=6hgWTSP1s2wmG7h3N837QUoQ@mail.gmail.com>
	<e0d58a$2cdsbh@orsmga002.jf.intel.com>
Date: Sat, 26 Nov 2011 22:29:12 +0600
Message-ID: <CADZ9YHinT6Y98Ks6Zs3UnG2xQSJYqDN5W1RgrNtyaPz-n8Zajg@mail.gmail.com>
Subject: Re: [PATCH] drm, i915: Fix memory leak in i915_gem_busy_ioctl().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>, akpm@linux-foundation.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 4:57 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Sat, 26 Nov 2011 10:44:17 +0600, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> On Mon, Nov 21, 2011 at 11:16 PM, Keith Packard <keithp@keithp.com> wrote:
>> > On Mon, 21 Nov 2011 17:23:06 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
>> >
>> >> Indeed, nice catch (albeit totally unlikely to be hit, because the error
>> >> only happens when the gpu ceases to progress in the ring, so imo not
>> >> stable material). Keith, please pick this up for fixes, thanks.
>> >
>> > It's already there and queued for airlied :-)
>> >
>> Thank you guys for reviewing and taking the patch.
>>
>> Now, while I was looking at the uses of i915_add_request(), I found
>> the following code :
>>
>>                         ret = i915_gem_flush_ring(ring, 0,
>> I915_GEM_GPU_DOMAINS);
>>                         request = kzalloc(sizeof(*request), GFP_KERNEL);
>>                         if (ret || request == NULL ||
>>                             i915_add_request(ring, NULL, request))
>>                             kfree(request);
>>
>> From above code, we might ended up by calling kfree(request) without
>> allocating request. Though, it's unlikely cause if request is NULL
>> then BUG_ON will be hit in i915_add_request(). So, to unify the callee
>> uses of i915_add_request(), I'm proposing the following patch. Please
>> let me know what do you guys think. If you guys agree, I can sent a
>> formal patch.
>
> kfree(NULL) is permitted and taken advantage of here along with the
> short-circuiting behaviour of '||'.

Yes, no real problem with current code. I was just thinking from code
cleanup's pov. Is BUG_ON really needed in i915_add_request() ?

thanks,
Rakib
