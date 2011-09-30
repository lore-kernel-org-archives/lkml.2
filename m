Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1I3Kbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 06:31:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:25616 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab1I3Kbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 06:31:51 -0400
Message-Id: <d08817$1mllv9@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,466,1312182000"; 
   d="scan'208";a="57333737"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 18/21] drm/i915: Disable eDP VDD in a delayed work proc instead of synchronously
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
In-Reply-To: <1317344993-24945-19-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-19-git-send-email-keithp@keithp.com>
Date: Fri, 30 Sep 2011 11:31:45 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 18:09:50 -0700, Keith Packard <keithp@keithp.com> wrote:
> +static void ironlake_panel_vdd_work(struct work_struct *__work)
> +{
> +	struct intel_dp *intel_dp = container_of(to_delayed_work(__work),
> +						 struct intel_dp, panel_vdd_work);
> +	struct drm_device *dev = intel_dp->base.base.dev;
> +
> +	mutex_lock(&dev->struct_mutex);
> +	ironlake_panel_vdd_off_sync(intel_dp);
> +	mutex_unlock(&dev->struct_mutex);

I think you want the dev->mode_config.mutex here.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
