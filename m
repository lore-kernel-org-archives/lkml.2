Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0HKQzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:55:52 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5665 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0HKQzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:55:51 -0400
Message-ID: <4C62D616.9050000@caviumnetworks.com>
Date: Wed, 11 Aug 2010 09:55:50 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <biessmann@corscience.de>
CC: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH] cavium-octeon: determine if helper should build
References: <1281545393-23690-1-git-send-email-biessmann@corscience.de>
In-Reply-To: <1281545393-23690-1-git-send-email-biessmann@corscience.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Aug 2010 16:55:50.0573 (UTC) FILETIME=[0D81DDD0:01CB3976]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 09:49 AM, Andreas Bießmann wrote:
>   This patch adds an config switch to determine if we need to build some
>   workaround helper files.
>
>   The staging driver octeon-ethernet references some symbols which are only
>   built when PCI is enabled. The new config switch enables these symbols in
>   bothe cases.
>
> Signed-off-by: Andreas Bießmann<biessmann@corscience.de>

Acked-by: David Daney <ddaney@caviumnetworks.com>


> ---
>   arch/mips/cavium-octeon/Kconfig            |    4 ++++
>   arch/mips/cavium-octeon/executive/Makefile |    2 +-
>   2 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/Kconfig b/arch/mips/cavium-octeon/Kconfig
> index 094c17e..47323ca 100644
> --- a/arch/mips/cavium-octeon/Kconfig
> +++ b/arch/mips/cavium-octeon/Kconfig
> @@ -83,3 +83,7 @@ config ARCH_SPARSEMEM_ENABLE
>   	def_bool y
>   	select SPARSEMEM_STATIC
>   	depends on CPU_CAVIUM_OCTEON
> +
> +config CAVIUM_OCTEON_HELPER
> +	def_bool y
> +	depends on OCTEON_ETHERNET || PCI
> diff --git a/arch/mips/cavium-octeon/executive/Makefile b/arch/mips/cavium-octeon/executive/Makefile
> index 2fd66db..7f41c5b 100644
> --- a/arch/mips/cavium-octeon/executive/Makefile
> +++ b/arch/mips/cavium-octeon/executive/Makefile
> @@ -11,4 +11,4 @@
>
>   obj-y += cvmx-bootmem.o cvmx-l2c.o cvmx-sysinfo.o octeon-model.o
>
> -obj-$(CONFIG_PCI) += cvmx-helper-errata.o cvmx-helper-jtag.o
> +obj-$(CONFIG_CAVIUM_OCTEON_HELPER) += cvmx-helper-errata.o cvmx-helper-jtag.o

