Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934629Ab1KJNqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:46:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:52574 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934545Ab1KJNqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:46:44 -0500
Subject: Re: [RFC PATCH 13/17] powerpc/e500: Add a new CONFIG_FSL_E5500 option for the e5500
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1320883635-17194-14-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Thu, 10 Nov 2011 07:46:08 -0600
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <20F26EAB-5DDA-4B65-913E-479653AD27D3@kernel.crashing.org>
References: <4E42AB6F.1050900@freescale.com> <1320883635-17194-14-git-send-email-Kyle.D.Moffett@boeing.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 9, 2011, at 6:07 PM, Kyle Moffett wrote:

> As part of splitting CONFIG_E500 into separate options for e500v1/v2 and
> e500mc/e5500, some code only needs to be built when e5500 support is
> required.
> 
> This adds a new internal-use config option for both 32-bit and 64-bit
> builds that enables only the e5500 support code.
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
> arch/powerpc/platforms/85xx/Kconfig    |    2 +-
> arch/powerpc/platforms/Kconfig.cputype |    4 ++++
> 2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
> index 248f87c..72488d4 100644
> --- a/arch/powerpc/platforms/85xx/Kconfig
> +++ b/arch/powerpc/platforms/85xx/Kconfig
> @@ -231,8 +231,8 @@ endif # PPC32
> config P5020_DS
> 	bool "Freescale P5020 DS"
> 	depends on FSL_E500MC || PPC_BOOK3E_64
> +	select FSL_E5500
> 	select DEFAULT_UIMAGE
> -	select E500
> 	select PHYS_64BIT_DT_REQUIRED
> 	select SWIOTLB
> 	select ARCH_REQUIRE_GPIOLIB
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index fd37bb2..cff45e3 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -144,6 +144,10 @@ config 8xx
> config PPC_85xx
> 	bool
> 
> +config FSL_E5500
> +	bool
> +	select E500
> +
> config E500
> 	select FSL_EMB_PERFMON
> 	select PPC_FSL_BOOK3E
> -- 
> 1.7.2.5

Nak, I don't want to add a unique build option for 64-bit E5500 vs E500MC.  We have E6500 coming and I don't want to introduce CONFIG_FSL_E6500 at that point.

- k

