Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2JKMG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:06:29 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:40325 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2JKMG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:06:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "Shi, Yang A" <yang.a.shi@intel.com>
Subject: Re: [Patch 0/1]drm_irq: Introducing the irq_thread support
Date: Thu, 11 Oct 2012 14:07:11 +0200
Message-ID: <2047810.N82l1KJrzR@avalon>
User-Agent: KMail/4.9.2 (Linux/3.4.9-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20120905132724.GC5357@phenom.ffwll.local>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com> <20120905132724.GC5357@phenom.ffwll.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2012 15:27:24 Daniel Vetter wrote:
> On Wed, Sep 05, 2012 at 01:53:44AM +0000, Liu, Chuansheng wrote:
> > This patch is for introducing the irq thread support in drm_irq.
> > 
> > Why we need irq thread in drm_irq code?
> > In our GPU system, the gpu interrupt handler need some time even > 1ms to
> > finish, in that case, the whole system will stay in irq disable status.
> > One case is: when audio is playing, it sometimes effects the audio
> > quality.
> > 
> > So we have to introduce the irq thread in drm_irq, it can help us move
> > some heavy work into irq thread and other irq interrupts can be handled
> > in time. Also the IRQF_ONESHOT is helpful for irq thread.
> > 
> > Include one patch:
> > [PATCH 01/1] drm_irq-Introducing-the-irq_thread-support
> 
> For a kms drm driver (and tbh, doing a non-kms driver today is not a great
> idea), there's no reason to use the drm_irq_install/_unistall helpers.

Should the documenation be updated to mark those functions as deprecated for 
new drivers and explain how to handle IRQ (un)registration manually ?

> So if you driver has special needs wrt irq handling that don't neatly fit
> what the drm_irq stuff provides, simply don't use it - all the generic
> code that's there is just to keep non-kms userspace going.

-- 
Regards,

Laurent Pinchart

