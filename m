Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1DEO2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:28:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:32181 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1DEO17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:27:59 -0400
Message-Id: <1bdc18$k44m31@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,304,1299484800"; 
   d="scan'208";a="675436641"
Date: Tue, 05 Apr 2011 15:27:54 +0100
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before KMS takeover
Cc: Tomas Winkler <tomasw@gmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com> <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk> <20110401114429.GA3526@viiv.ffwll.ch> <AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com> <BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com> <b7da2f$qvoau5@fmsmga001.fm.intel.com> <BANLkTi=kXod21RUukrTuMzP5TFqgo4NxRw@mail.gmail.com> <BANLkTins76X1mOFepqXEQjMEh_hd4Vgw1Q@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <BANLkTins76X1mOFepqXEQjMEh_hd4Vgw1Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 17:11:56 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> [    9.310010]  <IRQ>  [<ffffffff8168cd0c>] panic+0x91/0x19e
> [    9.310010]  [<ffffffff816909ea>] oops_end+0xea/0xf0
> [    9.310010]  [<ffffffff8106afbb>] no_context+0xfb/0x260
> [    9.310010]  [<ffffffff8106b245>] __bad_area_nosemaphore+0x125/0x1e0
> [    9.310010]  [<ffffffff8106b313>] bad_area_nosemaphore+0x13/0x20
> [    9.310010]  [<ffffffff816930c0>] do_page_fault+0x310/0x4c0
> [    9.310010]  [<ffffffff810ac06f>] ? up+0x2f/0x50
> [    9.310010]  [<ffffffff8108652f>] ? console_unlock+0x17f/0x1d0
> [    9.310010]  [<ffffffff8168fd25>] page_fault+0x25/0x30
> [    9.310010]  [<ffffffffa0061628>] ? i915_handle_error+0x198/0xed0 [i915]
> [    9.310010]  [<ffffffff8137d04a>] ? scsi_next_command+0x4a/0x60
> [    9.310010]  [<ffffffff8137ddd6>] ? scsi_io_completion+0x2f6/0x630
> [    9.310010]  [<ffffffffa0064c62>] i915_driver_irq_handler+0x472/0x17f0 [i915]
> 
> This is the same pre-2.6.39-rc1 kernel with the two patches applied.
> I'll try latest Linus master next to see if the same problem triggers.

Hmm. Looks like we don't prevent the PGTBL_ER with those patches (or we
provoke another), and trigger the error before we can handle it.

Double ungood. Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
