Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1KBJMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 05:12:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:60942 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab1KBJMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 05:12:20 -0400
Message-Id: <e39f63$2h6thv@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,443,1315206000"; 
   d="scan'208";a="85161535"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 6/7] drm/i915: Try harder during dp pattern 1 link training
To: Keith Packard <keithp@keithp.com>, intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
In-Reply-To: <1320214830-12696-7-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-7-git-send-email-keithp@keithp.com>
Date: Wed, 02 Nov 2011 09:12:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Nov 2011 23:20:29 -0700, Keith Packard <keithp@keithp.com> wrote:
> Instead of going through the sequence just once, run through the whole
> set up to 5 times to see if something can work. This isn't part of the
> DP spec, but the BIOS seems to do it, and given that link training
> failure is so bad, it seems reasonable to follow suit.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |   41 +++++++++++++++++++++++++-------------
>  1 files changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 6be6a04..bf20a35 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -1576,8 +1576,9 @@ intel_dp_set_link_train(struct intel_dp *intel_dp,
>  
>  	ret = intel_dp_aux_native_write(intel_dp,
>  					DP_TRAINING_LANE0_SET,
> -					intel_dp->train_set, 4);
> -	if (ret != 4)
> +					intel_dp->train_set,
> +					intel_dp->lane_count);
> +	if (ret != intel_dp->lane_count)
>  		return false;

This would seem to be a separate chunk to initiate training on only the
lanes we intend to use.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
