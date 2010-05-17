Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0EQLYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:24:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60362 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0EQLYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:24:00 -0400
Date: Mon, 17 May 2010 13:23:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org
Subject: Re: [PATCH] x86: CPU detection for RDC System-on-Chip
Message-ID: <20100517112358.GD20761@basil.fritz.box>
References: <201005161455.34100.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005161455.34100.florian@openwrt.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 39e8e10..21b02f2 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -419,6 +419,7 @@ config X86_RDC321X
>  	bool "RDC R-321x SoC"
>  	depends on X86_32
>  	depends on X86_EXTENDED_PLATFORM
> +	select PCI

If you don't actually need PCI in your SOC then you could easily
remove that dependency with some minor work. Early PCI really is quite 
independent from the other code and can be just used on its own. 

The only thing that would need sorting out is the command line 
interface for early_pci_enabled()

-Andi
