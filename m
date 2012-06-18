Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab2FRLhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:37:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57823 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2FRLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:37:21 -0400
Date: Mon, 18 Jun 2012 12:37:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Subject: Re: [RFC PATCH 8/8] ARM: vmlinux.lds: Setup correct entry point to
	physical address
Message-ID: <20120618113716.GG12029@n2100.arm.linux.org.uk>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu> <1340019011-18642-9-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340019011-18642-9-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 01:30:11PM +0200, Michal Simek wrote:
> linker script setups entry point to virtual address.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> ---
> Not sure what is the reason to setup entry point to virtual address.
> ---
>  arch/arm/kernel/vmlinux.lds.S |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index b996bc0..de43b01 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -39,7 +39,7 @@
>  #endif
>  
>  OUTPUT_ARCH(arm)
> -ENTRY(stext)
> +ENTRY(arm_start)

stext etc better stay as the virtual address through this change.  The
kernel makes use of all stext/etext etc symbols as virtual addresses.
