Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab1CKIHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 03:07:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:15873 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1CKIHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 03:07:43 -0500
Message-Id: <b7da2f$qmkuio@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,302,1297065600"; 
   d="scan'208";a="896170584"
Date: Fri, 11 Mar 2011 08:07:38 +0000
To: Indan Zupancic <indan@nul.nu>, Keith Packard <keithp@keithp.com>
Subject: Re: drm/i915: Fix DPMS and suspend interaction for intel_panel.c
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
References: <5e60ae646a15c73f5be0c309f51d1c63.squirrel@webmail.greenhost.nl>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <5e60ae646a15c73f5be0c309f51d1c63.squirrel@webmail.greenhost.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011 02:35:45 +0100 (CET), "Indan Zupancic" <indan@nul.nu> wrote:
> drm/i915: Fix DPMS and suspend interaction for intel_panel.c
> 
> When suspending intel_panel_disable_backlight() is never called,
> but intel_panel_enable_backlight() is called at resume. With the
> effect that if the brightness was ever changed after screen
> blanking, the wrong brightness gets restored at resume time.
> 
> Nothing guarantees that those calls will be balanced, so having
> backlight_enabled makes no sense, as the real state can change
> without the panel code noticing. So keep things as stateless as
> possible.

The problem is wider than described since the BIOS/ACPI may modify the
registers without notifying the driver, and we fail to honour any user
requests whilst the panel is off. Also, there is the greater of problem
that the PWM registers simply have no effect on many machines, and we
need to make an ACPI call to adjust the backlight.  However, this
behaviour has been there since the inception, we can wait until the next
merge cycle.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
