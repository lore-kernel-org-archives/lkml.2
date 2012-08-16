Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab2HPLKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:10:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52448 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab2HPLKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:10:48 -0400
Date: Thu, 16 Aug 2012 13:10:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120816111044.GA12029@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120816095439.GA30794@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120816095439.GA30794@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 11:54:39AM +0200, Thierry Reding wrote:
> How does the attached patch look?
> 
> Thierry

> From cd3199b94e697cccd38766b4a60d2e91474d0539 Mon Sep 17 00:00:00 2001
> From: Thierry Reding <thierry.reding@avionic-design.de>
> Date: Thu, 16 Aug 2012 08:01:21 +0200
> Subject: [PATCH] pwm: Improve Kconfig help text
> 
> The Kconfig help text should help the user understand what functionality
> is provided by an option. This is especially true for new subsystems. An
> improved help text is provided by this commit in the hopes of clarifying
> the usefulness of the PWM framework.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  drivers/pwm/Kconfig | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 8fc3808..88ddb9e 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -1,12 +1,24 @@
>  menuconfig PWM
> -	bool "PWM Support"
> +	bool "Pulse-Width Modulation (PWM) Support"
>  	depends on !MACH_JZ4740 && !PUV3_PWM
>  	help
> -	  This enables PWM support through the generic PWM framework.
> -	  You only need to enable this, if you also want to enable
> -	  one or more of the PWM drivers below.
> -
> -	  If unsure, say N.
> +	  Generic Pulse-Width Modulation (PWM) support.
> +
> +	  This framework provides a generic interface to PWM devices
> +	  within the Linux kernel. On the driver side it provides an API
> +	  to register and unregister a PWM chip, an abstraction of a PWM
> +	  controller, that supports one or more PWM devices. Client
> +	  drivers can request PWM devices and use the generic framework
> +	  to configure as well as enable and disable them.
> +
> +	  The new generic framework replaces the legacy PWM framework
> +	  which allows only a single driver implementing the required
> +	  API. Not all legacy implementations have been ported to the
> +	  new framework yet. The new framework provides an API that is
> +	  backward compatible with the legacy framework so that existing
> +	  client drivers continue to work as expected.
> +
> +	  If unsure, say no.

Yes, this is much better than what we had before. I'd suggest though,
that instead of describing the high-level software design of the PWM
subsystem, the text should be more addressed to the simple user like me
who would like to know what this thing is and why do I want to enable
it. Basically summarize what PWN devices are and what they're used for.
I.e., https://en.wikipedia.org/wiki/Pulse-width_modulation#Applications
but in 4-5 lines of text.

IMHO, of course.

Thanks.

-- 
Regards/Gruss,
Boris.
