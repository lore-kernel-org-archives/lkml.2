Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1I0Q4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:56:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:17303 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1I0Q4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:56:45 -0400
Message-Id: <e0d58a$1mfht8@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57132968"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 9/9] drm/i915: Initialize PCH refclks at modeset init time
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
In-Reply-To: <1317103906-4649-10-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-10-git-send-email-keithp@keithp.com>
Date: Tue, 27 Sep 2011 17:56:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 23:11:46 -0700, Keith Packard <keithp@keithp.com> wrote:
> The reference clock configuration must be done before any mode setting
> can occur as all outputs must be disabled to change
> anything. Initialize the clocks after turning everything off during
> the initialization process.

Ah, now I see why we moved from using the active configuration earlier. ;-)

Doesn't this prevent us from ever using SSC though, as virtually every
single PCH machine has HDMI encoders that haven't been masked out through
the chicken fuses or VBT?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
