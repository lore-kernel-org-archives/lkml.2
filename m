Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab0FQUKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:10:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19508 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab0FQUKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:10:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6016"; a="44759366"
Subject: Re: [PATCH 1/2] arm: msm: Add gpiolib support for MSM7200A-family
 chips.
From: Daniel Walker <dwalker@codeaurora.org>
To: Greg Bean <gbean@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4C1A7FDA.1070607@codeaurora.org>
References: <1276656228-9376-1-git-send-email-gbean@codeaurora.org>
	 <1276656228-9376-2-git-send-email-gbean@codeaurora.org>
	 <1276804850.29614.61.camel@c-dwalke-linux.qualcomm.com>
	 <4C1A7FDA.1070607@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 13:10:35 -0700
Message-ID: <1276805435.29614.67.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 13:04 -0700, Greg Bean wrote:
> >> +config MSM7200A_GPIO
> >> +	tristate "Qualcomm MSM7200A SoC GPIO support"
> >> +	depends on GPIOLIB
> >> +	help
> >> +	  Say yes here to support GPIO functionality on Qualcomm's
> >> +	  MSM chipsets which descend from the MSM7200a:
> >> +	  MSM7x01(a), MSM7x25, MSM7x27, MSM7x30, QSD8x50(a).
> >
> > Can't we drop this? It's always going to be on right ?
> 
> Not on all targets.  There will be other drivers for chips from other 
> lines.  However, I would think that it could be entirely reasonable to 
> lose the Kconfig and just hard-wire it in based on ARCH, if you like. 
> Is that preferred?

Yeah, it's better not to have Kconfig options like this since it's
easier for the user if we just encode this into options we know they
have to select already.

So for example they pick 8x50 via Kconfig, so we select for them the
right stuff for 8x50 .. Otherwise we have to assume they know what to
select which may not be the case, plus it could be a pain to go
selecting all the related Kconfig options for low level stuff.

If you respin this please re-send it privately just to me.

Daniel

