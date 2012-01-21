Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2AUEsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 23:48:20 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37457 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561Ab2AUEsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 23:48:18 -0500
Date: Fri, 20 Jan 2012 20:46:31 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/platform: (TS-5500) revised ADC driver
Message-ID: <20120121044631.GA4143@ericsson.com>
References: <1326930731-21215-5-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1327103002-5834-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1327103002-5834-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 06:43:22PM -0500, Vivien Didelot wrote:
> Update of the ADC driver according to the Guenter Roeck's review.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>  arch/x86/platform/ts5500/ts5500_adc.c |  228 +++++++++++++--------------------
>  1 files changed, 89 insertions(+), 139 deletions(-)
> 
> diff --git a/arch/x86/platform/ts5500/ts5500_adc.c b/arch/x86/platform/ts5500/ts5500_adc.c
> index fc4560f..da6decf 100644
> --- a/arch/x86/platform/ts5500/ts5500_adc.c
> +++ b/arch/x86/platform/ts5500/ts5500_adc.c
> @@ -62,57 +62,62 @@
>  
Hi Vivien,

This isn't really a revised driver ... it is a patch on top of the previous version.

Regarding the location, I'd really like to know from the powers-that-be if
	arch/x86/platform/ts5500/
or
	drivers/platform/x86
or
	drivers/hwmon

would be the appropriate location for a driver like this. As mentioned before,
my strong preference is drivers/hwmon, but I would like to hear from others.

Also, I am not sure if the current approach is appropriate to start with.
Looking at the datasheet as well as into existing kernel code, it appears quite likely 
that some kind of more or less generic MAX197 driver exists somewhere. The existence 
of is_max197_installed() - without any calling code - is a strong indication that
this is the case, as well as the "static" platform data in your original patch.
It might be more appropriate to take this more or less generic driver, move it to
drivers/hwmon, and provide - for example through platform data - a means
to read from and write to the chip on a per-platform basis, ie with per-platform
access functions.

Thanks,
Guenter
