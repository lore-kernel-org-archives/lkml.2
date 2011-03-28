Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1C1TJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:09:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:50691 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab1C1TJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:09:26 -0400
Message-Id: <849307$c6tdto@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,257,1299484800"; 
   d="scan'208";a="409909176"
Date: Mon, 28 Mar 2011 20:09:13 +0100
To: Pekka Enberg <penberg@kernel.org>, Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] drm fixes for -rc1
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1103241132001.12023@skynet.skynet.ie> <AANLkTi=g27c3_Meu-YymXNPSD+isonN7CuWg78F9ZA+j@mail.gmail.com> <AANLkTimAwNytQaykaMf33DUXcKOyGVWUetOAb_nf236t@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTimAwNytQaykaMf33DUXcKOyGVWUetOAb_nf236t@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 21:53:32 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> On Mon, Mar 28, 2011 at 9:43 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > On Thu, Mar 24, 2011 at 1:34 PM, Dave Airlie <airlied@linux.ie> wrote:
> >> It should have the fix for your i915 in the intel patches, along with
> >> a couple of radeon fixes, and the vblank change + fix.
> >
> > I'm seeing some laptop screen flicker during boot and a while after I
> > log in (it then seems to go away). It's my trusty old Macbook with
> > i915 and Ubuntu 10.04. I see this in dmesg:
> >
> > [    1.782046] [drm] initialized overlay support
> > [    1.782075] [drm] capturing error event; look for more information
> > in /debug/dri/0/i915_error_state
> > [    1.782889] render error detected, EIR: 0x00000010
> > [    1.782933] page table error
> > [    1.782970]   PGTBL_ER: 0x00000102
> > [    1.783009] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck:
> > 0x00000010, masking
> > [    1.783063] render error detected, EIR: 0x00000010
> > [    1.783106] page table error
> > [    1.783143]   PGTBL_ER: 0x00000102
> >
> > I'm attaching the full dmesg, i915_error_state, and .config.

Right, looks like we have an issue with setting up the hardware for
KMS/GEM whilst it is still active. As we disable the outputs anyway for
the KMS takeover, we can arrange to do so first and so prevent this bug.
The side-effect will be that initial screen blanking will last a little
bit longer.

> I'm also seeing these errors now which seem to be new from 2.6.38-final:
> 
> [  437.566022] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
> purgeable buffer
> [  437.566187] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
> purgeable buffer
> [  437.566232] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
> purgeable buffer
> [  437.566275] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
> purgeable buffer
> [  437.566318] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
> purgeable buffer

That's an old userspace bug, which so far no one has been able to
reproduce on the upstream ddx.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
