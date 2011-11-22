Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1KVHoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 02:44:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:35720 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab1KVHoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 02:44:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,552,1315206000"; 
   d="scan'208";a="88007070"
Date: Tue, 22 Nov 2011 15:40:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] drm/i915: hot plug/unplug notification to HDMI
 audio driver
Message-ID: <20111122074055.GA21560@localhost>
References: <20111121063749.GA23450@localhost>
 <86hb1xife8.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86hb1xife8.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:55:43AM +0800, Keith Packard wrote:
> On Mon, 21 Nov 2011 14:37:49 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On monitor hot plug/unplug, update ELD and set/clear SDVO_AUDIO_ENABLE
> > or DP_AUDIO_OUTPUT_ENABLE accordingly.  So that the audio driver will
> > receive hot plug events and take action to refresh its device state and
> > ELD contents.
> > 
> > A new callback ->hotplug() is added to struct drm_connector_funcs which
> > will be called immediately after ->detect() knowing that the monitor is
> > either plugged or unplugged.
> > 
> > It's noticed that X may not call ->mode_set() at monitor hot plug, so it's
> > necessary to call drm_edid_to_eld() earlier at ->detect() time rather than
> > in intel_ddc_get_modes(), so that intel_write_eld() can see the new ELD
> > in ->hotplug.
> 
> The X environment will eventually call mode_set when the user
> environment decides to use the monitor. Any audio bits can, and should,
> await the user's choice of a video mode before choosing the audio format
> to use. We should not be adding eld information until the monitor is in
> use.

Yeah. I just tested the full gnome desktop and find it behave like the
KMS console:

1) ->mode_set will be called
2) crtc is 0 in intel_hdmi_hotplug(), hence skipping the ELD code there

So the v3 patch will behave equally well on KMS console, gnome desktop
and bare X. Shall we just use it, or go back and use the original
->hot_remove patch?

Thanks,
Fengguang
