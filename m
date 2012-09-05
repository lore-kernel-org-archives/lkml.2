Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2IEN05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:26:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46026 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2IEN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:26:54 -0400
Date: Wed, 5 Sep 2012 15:27:24 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "Shi, Yang A" <yang.a.shi@intel.com>
Subject: Re: [Patch 0/1]drm_irq: Introducing the irq_thread support
Message-ID: <20120905132724.GC5357@phenom.ffwll.local>
Mail-Followup-To: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
	"'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"alexander.deucher@amd.com" <alexander.deucher@amd.com>,
	"airlied@redhat.com" <airlied@redhat.com>,
	"Shi, Yang A" <yang.a.shi@intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 01:53:44AM +0000, Liu, Chuansheng wrote:
> This patch is for introducing the irq thread support in drm_irq.
> 
> Why we need irq thread in drm_irq code?
> In our GPU system, the gpu interrupt handler need some time even > 1ms to finish,
> in that case, the whole system will stay in irq disable status. One case is:
> when audio is playing, it sometimes effects the audio quality.
> 
> So we have to introduce the irq thread in drm_irq, it can help us move some heavy work into irq thread
> and other irq interrupts can be handled in time. Also the IRQF_ONESHOT is helpful for irq thread.
> 
> Include one patch:
> [PATCH 01/1] drm_irq-Introducing-the-irq_thread-support

For a kms drm driver (and tbh, doing a non-kms driver today is not a great
idea), there's no reason to use the drm_irq_install/_unistall helpers.

So if you driver has special needs wrt irq handling that don't neatly fit
what the drm_irq stuff provides, simply don't use it - all the generic
code that's there is just to keep non-kms userspace going.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
