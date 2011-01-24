Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1AXTNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:13:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:30174 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab1AXTN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:13:29 -0500
Message-Id: <0d30dc$krk6f6@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,371,1291622400"; 
   d="scan'208";a="700062216"
Date: Mon, 24 Jan 2011 19:13:25 +0000
To: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG/REGRESSION] DRM / i915 / 2.6.37 and 2.6.38-rc*: DVI output gets disabled/reenabled under load
Cc: jesse.barnes@intel.com
References: <4D3DC997.5040605@t-online.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4D3DC997.5040605@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 19:48:55 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> On an AOpen i915GMm-HFS I see the following problem:
> The LCD panel connected to DVI-1 gets disabled and then reenabled
> under high system load (e.g. -j 15 kernel compile) if I am working on the
> framebuffer console (no problems in X).

DVI detection is essentially retrieving the EDID by bitbanging on the DDC.
This is timing sensitive and I suspect that is being interrupted by the
system activity causing the EDID data to be returned corrupted. Is that
supported by any warnings in dmesg? Does increasing the drm.debug level to
0x6 reveal any more significant information?

Not sure how using the unaccelerated fbcon ties in just yet. It's an extra
source of latency vs X, but I would expect to impact upon DVI detection.

You can simply disable the polling with
'echo n > /sys/module/drm_kms_helper/parameter/poll'
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
