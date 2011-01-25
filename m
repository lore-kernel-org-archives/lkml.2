Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1AYNug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:50:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:57064 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1AYNuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:50:35 -0500
Message-Id: <b7da2f$q7ufnf@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,374,1291622400"; 
   d="scan'208";a="880754421"
Date: Tue, 25 Jan 2011 13:50:31 +0000
To: Knut Petersen <Knut_Petersen@t-online.de>
Subject: Re: [BUG/REGRESSION] DRM / i915 / 2.6.37 and 2.6.38-rc*: DVI output gets disabled/reenabled under load
Cc: jesse.barnes@intel.com, linux-kernel@vger.kernel.org
References: <4D3DC997.5040605@t-online.de> <0d30dc$krk6f6@orsmga001.jf.intel.com> <4D3EB90C.9020901@t-online.de> <0d30dc$krt8da@orsmga001.jf.intel.com> <4D3EC393.3010403@t-online.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4D3EC393.3010403@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 13:35:31 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> Attached find the startup logs. Both debuglevel 0xf.

2.6.36:
> [    2.699943] [drm:intel_sdvo_debug_write], SDVOC: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
> [    2.736984] [drm:intel_sdvo_debug_response], SDVOC: R: 02 C2 01 01 01 3D 3E 00 (Success)

2.6.38:
> [    2.561275] [drm:intel_sdvo_debug_write], SDVOC: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
> [    2.565952] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 C2 01 01 01 3D 3E 00
> [    2.579730] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
> [    2.579735]   vendor_id: 2
> [    2.579736]   device_id: 194
> [    2.579737]   device_rev_id: 1
> [    2.579738]   sdvo_version_major: 1
> [    2.579739]   sdvo_version_minor: 1
> [    2.579740]   sdvo_inputs_mask: 1
> [    2.579741]   smooth_scaling: 1
> [    2.579742]   sharp_scaling: 1
> [    2.579743]   up_scaling: 1
> [    2.579744]   down_scaling: 1
> [    2.579745]   stall_support: 0
> [    2.579746]   output_flags: 62

Both report output_flags of 0x3e, which includes VGA and a few
complementary TV out modes. The VGA-2 seems to be ignored by 2.6.36, but
does seem legitimate. Hmm.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
