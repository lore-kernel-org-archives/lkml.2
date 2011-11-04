Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1KDWRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:17:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59163 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733Ab1KDWRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:17:33 -0400
Date: Fri, 4 Nov 2011 22:17:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 RESEND] ASoC: wm9081: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111104221730.GA16978@opensource.wolfsonmicro.com>
References: <1318993587.7128.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318993587.7128.7.camel@phoenix>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 11:06:27AM +0800, Axel Lin wrote:

>  			/* Normal bias enable & soft start off */
> -			reg |= WM9081_BIAS_ENA;
> -			reg &= ~WM9081_VMID_RAMP;
> -			snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
> +			snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
> +					    WM9081_VMID_RAMP | WM9081_BIAS_ENA |
> +					    WM9081_VMID_SEL_MASK,
> +					    WM9081_BIAS_ENA);

This looks (and sounds) wrong - the original code didn't touch
VMID_SEL_MASK for this update but the new version will clear
VMID_SEL_MASK.  Even with that fixed there still seems to be some issue
here, though.
