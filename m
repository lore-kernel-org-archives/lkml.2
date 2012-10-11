Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab2JKPSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:18:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62694 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2JKPSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:18:03 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAF6AEGsd7AyBzJhAt-HTZ+NHajOEUnfpaz2u-KmBS1JWs2yHtA@mail.gmail.com>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
	<20120905132724.GC5357@phenom.ffwll.local>
	<2047810.N82l1KJrzR@avalon>
	<CAF6AEGsd7AyBzJhAt-HTZ+NHajOEUnfpaz2u-KmBS1JWs2yHtA@mail.gmail.com>
Date: Thu, 11 Oct 2012 17:18:00 +0200
X-Google-Sender-Auth: GIWys_9E05gHnudsf5VzArhy-Fw
Message-ID: <CAKMK7uFMAx=+ziO5bS6cr+f1x2b5GHCOFsFFTkPJOXOZsF+USw@mail.gmail.com>
Subject: Re: [Patch 0/1]drm_irq: Introducing the irq_thread support
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Clark <robdclark@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Shi, Yang A" <yang.a.shi@intel.com>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 3:19 PM, Rob Clark <robdclark@gmail.com> wrote:
>> Should the documenation be updated to mark those functions as deprecated for
>> new drivers and explain how to handle IRQ (un)registration manually ?

They're not deprecated, since for most drivers they're good enough.
Maybe just make it clear that they're optional (and whoever's the
first might need to do some refactoring to make things simpler for
fancy irq handling).

> It might be nice to provide the driver an option to give it's own
> install/uninstall irq fxn ptrs.. this way we can keep
> drm_irq_install/uninstall().  In particular, the uninstall fxn still
> does some useful cleanup like wake up anyone waiting for vblank events
> which would still be needed by drivers registering irq in their own
> special way.  And the irq pre/post-install stuff is still a bit nice
> to keep.

If a driver needs its own irq setup/teardown magic, I'd prefer if we
simply extract the useful parts of the common code into a little
helper that drivers can call, and don't add new&fancy callbacks and
interface. At least not without really good reasons.

/me has seen enough midlayer awesomeness in drm land already

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
