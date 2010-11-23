Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0KWJIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:08:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:59393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab0KWJIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:08:44 -0500
Message-Id: <b9dded$h5thli@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,241,1288594800"; 
   d="scan'208";a="576636594"
Date: Tue, 23 Nov 2010 09:08:40 +0000
To: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: Re: [i915] 2.6.37-rc1 G33 regression : no DVI output
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <4CE95893.8040008@gmail.com>
References: <AANLkTinEbBirwkREAVaaB4gH0w44tem0ik9nPU5-6aNJ@mail.gmail.com> <c6d829$pk1i4l@fmsmga001.fm.intel.com> <4CE95893.8040008@gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 18:36:19 +0100, Vincent Vanackere <vincent.vanackere@gmail.com> wrote:
> [    8.740024] [drm:drm_crtc_helper_set_mode], [ENCODER:7:TMDS-7] set [MODE:13:1920x1200]
> [    8.740027] [drm:intel_sdvo_debug_write], SDVOB: W: 07 01 00 00 00             (SDVO_CMD_SET_IN_OUT_MAP)
> [    8.747826] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
> [    8.747828] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
> [    8.753161] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
> [    8.758485] [drm:intel_sdvo_debug_write], SDVOB: W: 16 28 3C 80 A0 70 B0 23 40 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART1)
> [    8.771225] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
> [    8.771227] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
> [    8.775340] [drm:intel_sdvo_debug_write], SDVOB: W: 93 01 00                   (SDVO_CMD_SET_HBUF_INDEX)
> [    8.780688] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]

This was the bug. We aborted the modeset as we tried to perform an
unsupported command. Should be fixed by:

commit da79de97d254145dcb7c08c978b1093eac15ec9c
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Nov 22 11:12:46 2010 +0000

    drm/i915/sdvo: Only enable HDMI encodings only if the commandset is supported
    
    As we conflated intel_sdvo->is_hdmi with both having HDMI support on the
    ADD along with having HDMI support on the monitor, we would attempt to
    use HDMI encodings even if the interface did not support those commands.
    
    Reported-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Tested-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
    Reviewed-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>

available at
git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git
[drm-intel-fixes]
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
