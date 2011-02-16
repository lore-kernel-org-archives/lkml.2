Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab1BPWJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:09:26 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45511 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab1BPWJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:09:24 -0500
Date: Wed, 16 Feb 2011 15:09:21 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH OF 12/14] x86/rtc: don't register rtc if we the DT blob
Message-ID: <20110216220921.GI22837@angua.secretlab.ca>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-13-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295843342-1122-13-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 09:59:00AM +0530, Sebastian Andrzej Siewior wrote:
> or we might end up with two device nodes for the same hardware.
> 
> Cc: Andres Salomon <dilinger@queued.net>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/kernel/rtc.c |    3 +++
>  include/linux/of.h    |   12 ++++++++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
> index 6f39cab..3f2ad26 100644
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -6,6 +6,7 @@
>  #include <linux/acpi.h>
>  #include <linux/bcd.h>
>  #include <linux/pnp.h>
> +#include <linux/of.h>
>  
>  #include <asm/vsyscall.h>
>  #include <asm/x86_init.h>
> @@ -236,6 +237,8 @@ static __init int add_rtc_cmos(void)
>  		}
>  	}
>  #endif
> +	if (of_have_populated_dt())
> +		return 0;

Hmmm, should this hunk be moved to the next patch to preserve bisectability?

g.

