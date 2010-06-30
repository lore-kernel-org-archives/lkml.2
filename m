Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0F3SGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:06:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61518 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab0F3SGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:06:54 -0400
Date: Wed, 30 Jun 2010 11:05:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Andy Isaacson <adi@hexapodia.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, "Wang, Yong Y" <yong.y.wang@intel.com>,
       qi.wang@intel.com, joel.clark@intel.com,
       andrew.chih.howe.khor@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Packet hub driver of Topcliff PCH
Message-Id: <20100630110517.d8f3b875.randy.dunlap@oracle.com>
In-Reply-To: <4C2AF782.1070802@dsn.okisemi.com>
References: <4C204B0D.2030201@dsn.okisemi.com>
	<4C2AF782.1070802@dsn.okisemi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C2B8788.011B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 16:51:30 +0900 Masayuki Ohtak wrote:

> Hi Andy and Andrew
> 
> I have modified for your comments.
> Please confirm below.
> 
> ---
> 
> 
> Packet hub driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel’s upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. Packet hub is
> a special converter device in Topcliff PCH that translate AMBA transactions
> to PCI Express transactions and vice versa. Thus packet hub helps present
> all IO peripherals in Topcliff PCH as PCIE devices to IA system.
> Topcliff PCH have MAC address and Option ROM data.
> These data are in SROM which is connected to PCIE bus.
> Packet hub driver of Topcliff PCH can access MAC address and Option ROM data in
> SROM.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> Acked-by: Arnd <Arnd’s email address>

It's listed in the MAINTAINERS file.  Please use that.


> 
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index e023682..1851e97 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -4,6 +4,16 @@
>  
>  menu "Character devices"
>  
> +config PCH_PHUB
> +	tristate "PCH PHUB"
> +	depends on PCI
> +	help
> +	  Topcliff is a IOH for x86 embedded processor. This IOH is quite

	           is an IOH for x86 embedded processors.

> +	  different with the traditional IOH. Topcliff is a kind of ARM-based

	            from

> +	  processor and connected with PCIe bus (from x86 processor).
> +	  PHUB work as a gateway transform the PCIe transaction into the AMBA

	       works as a gateway to transform

> +	  transaction, and vise verse, and have several transform windows also.

	                   vice versa, and has several



Maybe lose some acromyns?  Overall, this help text should be about
*what* PCH_PHUB is, not *how* it accomplishes its work.
If you want to document *how* it works, put that into the source code
or Documentation/ somewhere.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
