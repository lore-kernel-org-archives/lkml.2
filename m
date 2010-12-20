Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0LTH5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 02:57:11 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:6982
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753747Ab0LTH5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 02:57:10 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz936eK1432N98dNzz1202hzz8275bh15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LDPVET-02-0IG-02
X-M-MSG: 
Date: Mon, 20 Dec 2010 08:54:54 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Benjamin <masterme120@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add optimisation option for k10 processors
Message-ID: <20101220075454.GB25977@aftab>
References: <1292795132.14811.10.camel@benjamin-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1292795132.14811.10.camel@benjamin-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 04:45:32PM -0500, Benjamin wrote:
> From: Benjamin Fair <masterme120@gmail.com>
> 
> This adds a config option to optimise for AMD family-k10 processors.

They're called AMD F10h processors, no more K*.

> Signed-off-by: Benjamin Fair <masterme120@gmail.com>
> 
> diff -uNr linux-2.6.37-rc6.vanilla/arch/x86/Kconfig.cpu
> linux-2.6.37-rc6/arch/x86/Kconfig.cpu
> --- linux-2.6.37-rc6.vanilla/arch/x86/Kconfig.cpu	2010-12-15
> 20:24:48.000000000 -0500
> +++ linux-2.6.37-rc6/arch/x86/Kconfig.cpu	2010-12-19 14:31:59.034429012
> -0500
> @@ -171,6 +171,13 @@
>  	  Enables use of some extended instructions, and passes appropriate
>  	  optimization flags to GCC.
>  
> +config MK10

config MF10H

> +	bool "Phenom/Phenom-II/Athlon-II/K10/10h"

	bool "Phenom/Phenom-II/Athlon-II, i.e. all F10h CPUs"

> +	---help---
> +	  Select this for an AMD K10-family processor.  Also known as Family
> +	  10h.  Enables use of some extended instructions, and passes
> +	  appropriate  optimization flags to GCC.
> +

ditto, no more K's.

[.. ]

> diff -uNr linux-2.6.37-rc6.vanilla/arch/x86/Makefile
> linux-2.6.37-rc6/arch/x86/Makefile
> --- linux-2.6.37-rc6.vanilla/arch/x86/Makefile	2010-12-15
> 20:24:48.000000000 -0500
> +++ linux-2.6.37-rc6/arch/x86/Makefile	2010-12-19 15:42:01.041429011
> -0500
> @@ -51,6 +51,7 @@
>  
>          # FIXME - should be integrated in Makefile.cpu
> (Makefile_32.cpu)
>          cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
> +        cflags-$(CONFIG_MK10) += $(call cc-option,-march=amdfam10)

But before we do that, let me talk to the compiler guys first.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

