Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab2BVJxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:53:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48868 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2BVJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:53:05 -0500
Date: Wed, 22 Feb 2012 09:52:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rmallon@gmail.com
Subject: Re: [PATCH v2 07/19] ARM: at91/pm_slowclock: function slow_clock()
	accepts parameters
Message-ID: <20120222095250.GV22562@n2100.arm.linux.org.uk>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com> <5b8fbdf669825987a82b3b89b2e7f02239cad816.1329903206.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b8fbdf669825987a82b3b89b2e7f02239cad816.1329903206.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:39:33AM +0100, Nicolas Ferre wrote:
> @@ -232,7 +246,7 @@ static int at91_pm_enter(suspend_state_t state)
>  				/* copy slow_clock handler to SRAM, and call it */
>  				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
>  #endif
> -				slow_clock();
> +				slow_clock(at91_pmc_base, at91_ramc0_base, at91_ramc1_base);

This should be updated to use the fncpy() stuff if there's any chance that
you'll be supporting Thumb-2.  Using fncpy() is probably a good idea even
if you aren't.  See asm/fncpy.h
