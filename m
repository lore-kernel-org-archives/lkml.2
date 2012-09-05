Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab2IEPMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:12:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:2920 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab2IEPMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:12:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,374,1344236400"; 
   d="scan'208";a="218402667"
From: "Shi, Yang A" <yang.a.shi@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>
Subject: RE: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Topic: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Index: AQHNi2ovBks1cguYJ0i+EYk7WekuB5d72mEw
Date: Wed, 5 Sep 2012 15:12:39 +0000
Message-ID: <E3ED5BF57CCD1C40876FA2D3385ED5D30FD781AC@SHSMSX102.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
 <20120905132724.GC5357@phenom.ffwll.local>
In-Reply-To: <20120905132724.GC5357@phenom.ffwll.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vetter:

    Do you mean we can just not use drm_irq_install, and make request_irq in our kernel driver pre-install or post-install interface?






Best Regards.
Yang Shi

PSI,System Integration, SH
E-mail:yang.a.shi@intel.com
Tel:88215666-4239


-----Original Message-----
From: Daniel Vetter [mailto:daniel.vetter@ffwll.ch] On Behalf Of Daniel Vetter
Sent: Wednesday, September 05, 2012 9:27 PM
To: Liu, Chuansheng
Cc: 'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org); dri-devel@lists.freedesktop.org; alexander.deucher@amd.com; airlied@redhat.com; Shi, Yang A
Subject: Re: [Patch 0/1]drm_irq: Introducing the irq_thread support

On Wed, Sep 05, 2012 at 01:53:44AM +0000, Liu, Chuansheng wrote:
> This patch is for introducing the irq thread support in drm_irq.
> 
> Why we need irq thread in drm_irq code?
> In our GPU system, the gpu interrupt handler need some time even > 1ms 
> to finish, in that case, the whole system will stay in irq disable status. One case is:
> when audio is playing, it sometimes effects the audio quality.
> 
> So we have to introduce the irq thread in drm_irq, it can help us move 
> some heavy work into irq thread and other irq interrupts can be handled in time. Also the IRQF_ONESHOT is helpful for irq thread.
> 
> Include one patch:
> [PATCH 01/1] drm_irq-Introducing-the-irq_thread-support

For a kms drm driver (and tbh, doing a non-kms driver today is not a great idea), there's no reason to use the drm_irq_install/_unistall helpers.

So if you driver has special needs wrt irq handling that don't neatly fit what the drm_irq stuff provides, simply don't use it - all the generic code that's there is just to keep non-kms userspace going.

Yours, Daniel
--
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
