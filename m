Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab2H3TrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:47:14 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:54327 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2H3TrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:47:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 173.50.127.139
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18BIVTmnJMJ9hl2z6gWuqt5C4gjojLhalk=
Date: Thu, 30 Aug 2012 15:47:06 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: David Brown <davidb@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Make sure dtc is built before running it
Message-ID: <20120830194706.GB19437@titan.lakedaemon.net>
References: <1346180398-8079-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346180398-8079-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 11:59:58AM -0700, David Brown wrote:
> 'make dtbs' in a clean tree will try running the dtc before actually
> building it.  Make these rules depend upon the scripts to build it.

David,

Could you please send this into rmk's queue? [1]  This fix has been
cropping up by various submitters for the past 6 months or so, it would
be nice to finally get it in.

thx,

Jason.

[1] http://www.arm.linux.org.uk/developer/patches/

> ---
>  arch/arm/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 0298b00..926d840 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -279,10 +279,10 @@ zImage Image xipImage bootpImage uImage: vmlinux
>  zinstall uinstall install: vmlinux
>  	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
>  
> -%.dtb:
> +%.dtb: scripts
>  	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
>  
> -dtbs:
> +dtbs: scripts
>  	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
>  
>  # We use MRPROPER_FILES and CLEAN_FILES now
> -- 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
