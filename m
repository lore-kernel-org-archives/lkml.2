Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab1AMQME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:12:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:50883 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933019Ab1AMQMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:12:03 -0500
Message-Id: <1bdc18$j8l825@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,318,1291622400"; 
   d="scan'208";a="646619205"
Date: Thu, 13 Jan 2011 16:10:59 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] drm/i915/execbuffer: Clear domains before beginning reloc processing
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimypim707rEXaPBaKoGgGmz3Of4EmPNw7VokJL6@mail.gmail.com>
References: <AANLkTinBnm+xkXPPM4-3PG_i2hJMuXhv8x42KN4o3kGg@mail.gmail.com> <1294916869-2417-1-git-send-email-chris@chris-wilson.co.uk> <AANLkTimypim707rEXaPBaKoGgGmz3Of4EmPNw7VokJL6@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011 07:54:59 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Thu, Jan 13, 2011 at 3:07 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > After reordering the sequence of relocating objects, commit 6fe4f1404,
> > we can no longer rely on seeing all reloc targets prior to performing
> > the relocation. So we need to clear the relocation domains earlier.
> 
> Yup, this one (together with the previous fix) seems to get rid of all
> the artifacts.
> 
> Should I just apply them as patches, or do you have a git branch to pull from?

They will be in drm-intel-fixes. There have been a couple of other patches,
for the compiler warning, the typo that Indan spotted and for modparam to
workaround the U160, so I'll send the pull request it via Dave.
-Chris

$ git shortlog linus..upstream/drm-intel-fixes
Chris Wilson (5):
      drm/i915/debugfs: Correct format after changing type of err object 'size'
      drm/i915: Add a module option to override the use of SSC
      drm/i915: Fix error handler to capture the first batch after the seqno
      drm/i915/execbuffer: Reorder relocations to match new object order
      drm/i915/execbuffer: Clear domains before beginning reloc processing

Indan Zupancic (1):
      drm/i915/panel: The backlight is enabled if the current value is non-zero

-- 
Chris Wilson, Intel Open Source Technology Centre
