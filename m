Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2CGMQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:16:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:49904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab2CGMQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:16:29 -0500
Message-Id: <aefc95$3e4c4e@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="115486862"
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
Date: Wed, 07 Mar 2012 12:15:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Mar 2012 19:50:44 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> Instead of letting other modules directly access the ->gmbus array,
> introduce a new API, intel_gmbus_get_bus(), to lookup an i2c_adapter for
> a given gmbus pin pair identifier.  This API enables later refactoring
> of the gmbus pin pair list.
> 
> Note: It is critical that intel_setup_gmbus() gets called before
> intel_gmbus_get_bus().

If you are going to rename it, perhaps a better choice than
intel_gmbus_get_bus(int gpio_pin) ?

intel_i2c_get_adapter(int gpio_pin) since the rest of the code really
does not care how the bits are transferred but that it interfaces using
i2c.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
