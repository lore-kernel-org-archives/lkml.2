Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0IVRKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:10:53 -0400
Received: from xenotime.net ([72.52.115.56]:37393 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752650Ab0IVRKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:10:51 -0400
Date: Wed, 22 Sep 2010 10:10:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH 2/3] PCI: OLPC configuration cleanup
Message-Id: <20100922101047.86a6cfcb.rdunlap@xenotime.net>
In-Reply-To: <20100922164402.A72D49D401B@zog.reactivated.net>
References: <20100922164402.A72D49D401B@zog.reactivated.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 17:44:02 +0100 (BST) Daniel Drake wrote:

> An OLPC system isn't usable without PCI, so we can simplify the
> configuration here.

preferably by using "depends on" instead of "select".


> Also updated the code to be clearer that this is only for XO-1, and
> fixed an issue where the XO-1 PCI configuration override was being
> applied for XO-1.5 laptops.
> 
> Based on earlier work by Deepak Saxena.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/Kconfig       |   12 +++---------
>  arch/x86/kernel/olpc.c |    4 +---
>  arch/x86/pci/Makefile  |    2 +-
>  arch/x86/pci/olpc.c    |    4 ++--
>  4 files changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cea0cd9..708ee0d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1899,10 +1899,6 @@ config PCI_GOMMCONFIG
>  config PCI_GODIRECT
>  	bool "Direct"
>  
> -config PCI_GOOLPC
> -	bool "OLPC"
> -	depends on OLPC
> -
>  config PCI_GOANY
>  	bool "Any"
>  
> @@ -1915,16 +1911,12 @@ config PCI_BIOS
>  # x86-64 doesn't support PCI BIOS access from long mode so always go direct.
>  config PCI_DIRECT
>  	def_bool y
> -	depends on PCI && (X86_64 || (PCI_GODIRECT || PCI_GOANY || PCI_GOOLPC))
> +	depends on PCI && (X86_64 || (PCI_GODIRECT || PCI_GOANY))
>  
>  config PCI_MMCONFIG
>  	def_bool y
>  	depends on X86_32 && PCI && (ACPI || SFI) && (PCI_GOMMCONFIG || PCI_GOANY)
>  
> -config PCI_OLPC
> -	def_bool y
> -	depends on PCI && OLPC && (PCI_GOOLPC || PCI_GOANY)
> -
>  config PCI_DOMAINS
>  	def_bool y
>  	depends on PCI
> @@ -2060,6 +2052,8 @@ config SCx200HR_TIMER
>  
>  config OLPC
>  	bool "One Laptop Per Child support"
> +	select PCI
> +	select PCI_GOANY
>  	select GPIOLIB
>  	---help---
>  	  Add support for detecting the unique features of the OLPC


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
