Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1D1V4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 17:56:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40343 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752761Ab1D1V4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 17:56:32 -0400
Date: Thu, 28 Apr 2011 22:56:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Williamson <michael.williamson@criticallink.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk, tiwai@suse.de
Subject: Re: [PATCH] audio: tlv320aic26: fix PLL register configuration
Message-ID: <20110428215639.GB19535@opensource.wolfsonmicro.com>
References: <1304026377-21829-1-git-send-email-michael.williamson@criticallink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304026377-21829-1-git-send-email-michael.williamson@criticallink.com>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 05:32:57PM -0400, Michael Williamson wrote:

> -	jval = (fsref == 44100) ? 7 : 8;
> -	dval = (fsref == 44100) ? 5264 : 1920;
> +	jval = fsref / (aic26->mclk / 2048);
> +	dval = fsref - jval * (aic26->mclk / 2048);

I'd like some more brackets on this line, especially given the
similarity with the previous line.  Otherwise this looks fine if a bit
magic:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
