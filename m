Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030837Ab2HQJTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:19:22 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54902 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933797Ab2HQJTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:19:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/nQ6Xdk7Yt2o9NsqE3L/D+
Date: Fri, 17 Aug 2012 02:19:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 13/31] arm64: Device specific operations
Message-ID: <20120817091908.GQ11011@atomide.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-14-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-14-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas <catalin.marinas@arm.com> [120814 11:05]:
> --- /dev/null
> +++ b/arch/arm64/mm/ioremap.c
> +
> +void __iomem *__ioremap(phys_addr_t phys_addr, size_t size, pgprot_t prot)
> +{
> +	return __ioremap_caller(phys_addr, size, prot,
> +				__builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(__ioremap);

>From SoC point of view, we're probably going to need __ioremap_exec()
here too for programming clocks during runtime in SRAM etc. But that
can be added later as needed.

Acked-by: Tony Lindgren <tony@atomide.com>
