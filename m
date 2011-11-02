Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab1KBRN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:13:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab1KBRNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:13:55 -0400
Message-ID: <4EB17A50.6050804@redhat.com>
Date: Wed, 02 Nov 2011 13:13:52 -0400
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Keith Packard <keithp@keithp.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most
 places
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <20111102092019.3a635632@jbarnes-desktop>
In-Reply-To: <20111102092019.3a635632@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/11 12:20 PM, Jesse Barnes wrote:

> @@ -766,10 +766,10 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
>   			continue;
>
>   		intel_dp = enc_to_intel_dp(encoder);
> -		if (intel_dp->base.type == INTEL_OUTPUT_DISPLAYPORT) {
> +		if (intel_dp->base.type == INTEL_OUTPUT_DISPLAYPORT || is_pch_edp(intel_dp)) {
>   			lane_count = intel_dp->lane_count;
>   			break;
> -		} else if (is_edp(intel_dp)) {
> +		} else if (is_cpu_edp(intel_dp)) {
>   			lane_count = dev_priv->edp.lanes;
>   			break;
>   		}
>
> I guess this means we can't trust the BIOS settings for PCH eDP?

Given the choice of trusting DPCD or the VBT, I'd definitely prefer DPCD.

- ajax

