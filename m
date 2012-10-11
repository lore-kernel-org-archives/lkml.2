Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab2JKNTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:19:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34650 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab2JKNTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <2047810.N82l1KJrzR@avalon>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
	<20120905132724.GC5357@phenom.ffwll.local>
	<2047810.N82l1KJrzR@avalon>
Date: Thu, 11 Oct 2012 08:19:16 -0500
Message-ID: <CAF6AEGsd7AyBzJhAt-HTZ+NHajOEUnfpaz2u-KmBS1JWs2yHtA@mail.gmail.com>
Subject: Re: [Patch 0/1]drm_irq: Introducing the irq_thread support
From: Rob Clark <robdclark@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, "Shi, Yang A" <yang.a.shi@intel.com>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 7:07 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Wednesday 05 September 2012 15:27:24 Daniel Vetter wrote:
>> On Wed, Sep 05, 2012 at 01:53:44AM +0000, Liu, Chuansheng wrote:
>> > This patch is for introducing the irq thread support in drm_irq.
>> >
>> > Why we need irq thread in drm_irq code?
>> > In our GPU system, the gpu interrupt handler need some time even > 1ms to
>> > finish, in that case, the whole system will stay in irq disable status.
>> > One case is: when audio is playing, it sometimes effects the audio
>> > quality.
>> >
>> > So we have to introduce the irq thread in drm_irq, it can help us move
>> > some heavy work into irq thread and other irq interrupts can be handled
>> > in time. Also the IRQF_ONESHOT is helpful for irq thread.
>> >
>> > Include one patch:
>> > [PATCH 01/1] drm_irq-Introducing-the-irq_thread-support
>>
>> For a kms drm driver (and tbh, doing a non-kms driver today is not a great
>> idea), there's no reason to use the drm_irq_install/_unistall helpers.
>
> Should the documenation be updated to mark those functions as deprecated for
> new drivers and explain how to handle IRQ (un)registration manually ?

It might be nice to provide the driver an option to give it's own
install/uninstall irq fxn ptrs.. this way we can keep
drm_irq_install/uninstall().  In particular, the uninstall fxn still
does some useful cleanup like wake up anyone waiting for vblank events
which would still be needed by drivers registering irq in their own
special way.  And the irq pre/post-install stuff is still a bit nice
to keep.

BR,
-R

>> So if you driver has special needs wrt irq handling that don't neatly fit
>> what the drm_irq stuff provides, simply don't use it - all the generic
>> code that's there is just to keep non-kms userspace going.
>
> --
> Regards,
>
> Laurent Pinchart
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
