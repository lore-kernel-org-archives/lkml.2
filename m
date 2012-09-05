Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab2IEPre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:47:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60541 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab2IEPrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:47:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120905132724.GC5357@phenom.ffwll.local>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
	<20120905132724.GC5357@phenom.ffwll.local>
Date: Wed, 5 Sep 2012 10:47:32 -0500
X-Google-Sender-Auth: kypNMbpLu_sqoY7E6qJQUvpv-7s
Message-ID: <CAF6AEGt_G4qE1ru32hzkWnoLi8qDh6+9x4=O93aKRvCRBc3eeQ@mail.gmail.com>
Subject: Re: [Patch 0/1]drm_irq: Introducing the irq_thread support
From: Rob Clark <rob.clark@linaro.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "Shi, Yang A" <yang.a.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 8:27 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Sep 05, 2012 at 01:53:44AM +0000, Liu, Chuansheng wrote:
>> This patch is for introducing the irq thread support in drm_irq.
>>
>> Why we need irq thread in drm_irq code?
>> In our GPU system, the gpu interrupt handler need some time even > 1ms to finish,
>> in that case, the whole system will stay in irq disable status. One case is:
>> when audio is playing, it sometimes effects the audio quality.
>>
>> So we have to introduce the irq thread in drm_irq, it can help us move some heavy work into irq thread
>> and other irq interrupts can be handled in time. Also the IRQF_ONESHOT is helpful for irq thread.
>>
>> Include one patch:
>> [PATCH 01/1] drm_irq-Introducing-the-irq_thread-support
>
> For a kms drm driver (and tbh, doing a non-kms driver today is not a great
> idea), there's no reason to use the drm_irq_install/_unistall helpers.
>
> So if you driver has special needs wrt irq handling that don't neatly fit
> what the drm_irq stuff provides, simply don't use it - all the generic
> code that's there is just to keep non-kms userspace going.

perhaps an easy thing would just be to allow the driver to provide
it's own request_irq?  That might be an easier way for devices that
need to register multiple irq's, etc?

Or is it better to just bypass and dev->irq_enabled=1?  That seemed a
bit like a hack to me, but the current irq code is more framework-ish,
and less helper-ish..

BR,
-R

> Yours, Daniel
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
