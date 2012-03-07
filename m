Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2CGMCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:02:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:26468 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab2CGMCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:02:30 -0500
Message-Id: <d08817$3eem0c@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115824652"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 3/9] drm/i915/intel_i2c: refactor using intel_gmbus_get_bus
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1331121050-17857-4-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org> <1331121050-17857-4-git-send-email-djkurtz@chromium.org>
Date: Wed, 07 Mar 2012 12:02:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Mar 2012 19:50:44 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> +struct i2c_adapter *intel_gmbus_get_bus(struct drm_i915_private *dev_priv,
> +					int pin)
> +{
BUG_ON(pin >= GMBUS_NUM_PORTS);

> +	return (pin < GMBUS_NUM_PORTS) ? &dev_priv->gmbus[pin].adapter : NULL;
You just turned a programming error into a nearly undecipherable OOPS.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
