Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2A3RDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:03:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52973 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2A3RDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:03:07 -0500
Message-ID: <4F26CD48.3040809@gmail.com>
Date: Mon, 30 Jan 2012 09:03:04 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix duplicate instances of ARCH_SPARSEMEM_ENABLE
References: <0736d2becb10905c35eec74f04c63970@localhost>
In-Reply-To: <0736d2becb10905c35eec74f04c63970@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2012 03:07 PM, Kevin Cernekee wrote:
> "config ARCH_SPARSEMEM_ENABLE" exists in both arch/mips/Kconfig and
> arch/mips/cavium-octeon/Kconfig, but the dependencies are not the same.
> This results in warnings when a non-Cavium platform tries to select
> ARCH_SPARSEMEM_ENABLE:
>
>      $ make lemote2f_defconfig ARCH=mips
>      warning: (LEMOTE_FULOONG2E&&  LEMOTE_MACH2F) selects ARCH_SPARSEMEM_ENABLE which has unmet direct dependencies (CPU_CAVIUM_OCTEON)
>      warning: (LEMOTE_FULOONG2E&&  LEMOTE_MACH2F) selects ARCH_SPARSEMEM_ENABLE which has unmet direct dependencies (CPU_CAVIUM_OCTEON)
>      #
>      # configuration written to .config
>      #
>
> Proposed workaround is to use a Cavium-specific config option which
> "select"s the desired options.
>
> Signed-off-by: Kevin Cernekee<cernekee@gmail.com>
> ---
>   arch/mips/cavium-octeon/Kconfig |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/Kconfig b/arch/mips/cavium-octeon/Kconfig
> index f9e275a..eda8266 100644
> --- a/arch/mips/cavium-octeon/Kconfig
> +++ b/arch/mips/cavium-octeon/Kconfig
> @@ -82,8 +82,9 @@ config CAVIUM_OCTEON_LOCK_L2_MEMCPY
>   	help
>   	  Lock the kernel's implementation of memcpy() into L2.
>
> -config ARCH_SPARSEMEM_ENABLE
> +config CAVIUM_OCTEON_SPARSEMEM_ENABLE
>   	def_bool y
> +	select ARCH_SPARSEMEM_ENABLE
>   	select SPARSEMEM_STATIC
>
>   config IOMMU_HELPER

NAK!

A cleaner patch for this was already done here:

http://patchwork.linux-mips.org/patch/3285/
