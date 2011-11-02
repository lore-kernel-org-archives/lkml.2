Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab1KBP34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab1KBP3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:29:54 -0400
Message-ID: <4EB161F1.5090003@redhat.com>
Date: Wed, 02 Nov 2011 11:29:53 -0400
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most
 places
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com>
In-Reply-To: <1320214830-12696-4-git-send-email-keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/11 2:20 AM, Keith Packard wrote:

> +		if (intel_dp->link_configuration [1] & DP_LANE_COUNT_ENHANCED_FRAME_EN)
> +			intel_dp->DP |= DP_ENHANCED_FRAMING;
> +
> +		/*
> +		 * Check for DPCD version>  1.1 and enhanced framing support
> +		 */
> +		if (intel_dp->dpcd[DP_DPCD_REV] >= 0x11 &&
> +		    (intel_dp->dpcd[DP_MAX_LANE_COUNT] & DP_ENHANCED_FRAME_CAP)) {
> +			intel_dp->link_configuration[1] |= DP_LANE_COUNT_ENHANCED_FRAME_EN;
> +			intel_dp->DP |= DP_ENHANCED_FRAMING;
> +		}

Redundant.  You've already done the link_configuration |= above in the 
common code.  You can drop the second if chunk altogether.

In related news, the corresponding section for this in TRANS_DP_CTL 
setup appears to turn on enhanced framing unconditionally.  This is 
probably not a big deal, I don't think I've ever seen a display not 
support it, but.

- ajax
