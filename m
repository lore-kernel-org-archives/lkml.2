Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2B2WdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:33:19 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:33384 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756541Ab2B2WdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:33:17 -0500
Message-ID: <4F4EA7B1.9060607@xenotime.net>
Date: Wed, 29 Feb 2012 14:33:21 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI / PCIe: Introduce command line option to disable
 ARI
References: <201202292309.42051.rjw@sisk.pl>
In-Reply-To: <201202292309.42051.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 02:09 PM, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> There are PCIe devices on the market that report ARI support but
> then fail to initialize correctly when ARI is actually used.  This
> leads to situations in which kernels 2.6.34 and newer fail to handle
> systems where the previous kernels worked without any apparent
> problems.  Unfortunately, it is currently unknown how many such
> devices are there.
> 
> For this reason, introduce a new kernel command line option,
> pci=noari, allowing users to disable PCIe ARI altogether if they
> see problems with PCIe device initialization.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/pci/pci.c
> ===================================================================
> --- linux.orig/drivers/pci/pci.c
> +++ linux/drivers/pci/pci.c
> @@ -94,6 +94,9 @@ u8 pci_cache_line_size;
>   */
>  unsigned int pcibios_max_latency = 255;
>  
> +/* If set, the PCIe ARI capability will not be used. */
> +static bool pcie_ari_disabled;


Please update Documentation/kernel-parameters.txt .

-- 
~Randy
