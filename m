Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1ISKKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 06:10:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:9977 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab1ISKKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 06:10:39 -0400
Message-Id: <aefc95$1fgrb6@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="49835366"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [BUG] i915 crashes X Server Constantly on Linux-3.1-rc4 to .rc6
To: Tarkan Erimer <tarkan.erimer@f-secure.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4E770FF5.8030207@f-secure.com>
References: <4E770FF5.8030207@f-secure.com>
Date: Mon, 19 Sep 2011 11:10:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011 12:48:37 +0300, Tarkan Erimer <tarkan.erimer@f-secure.com> wrote:
> Hi,
> 
> I'm having constant X crashes (Almost every 30 mins.) on Intel Graphics. 
> Below is the error message after X crashes :
> 
> [  113.264775] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
Sigh. A debugging message left at DRM_ERROR.

> [  113.265289] [drm] Changing LVDS panel from (-hsync, -vsync) to 
> (+hsync, -vsync)

This is just an info message as a few kernel releases ago we started
honouring LVDS sync from the EDID and so we wanted to make sure that no
regressions correlated with actually doing as we were told.

> [  114.141640] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
> [ 4955.770011] [drm:intel_disable_transcoder] *ERROR* failed to disable 
> transcoder

This is one the true error in the midst of this spew.

Aside from the one modesetting error, these messages are all secondary
to the crash (and are really just debugging spew whilst switching
modes from X to console, console to X). Can you please attach the
Xorg.log containing the crash? Or maybe gdm.log etc? Also what happens
regularly every 30minutes; a particular screensaver or dpms?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
