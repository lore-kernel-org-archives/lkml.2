Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab1DGXhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:37:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55594 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab1DGXhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:37:03 -0400
Date: Thu, 7 Apr 2011 16:35:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ameya Palande <ameya.palande@nokia.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] x86: Arrange X86_EXTENDED_PLATFORM options into
 hierarchy
Message-Id: <20110407163557.8db1da63.randy.dunlap@oracle.com>
In-Reply-To: <1302006466-5123-1-git-send-email-ameya.palande@nokia.com>
References: <1302006466-5123-1-git-send-email-ameya.palande@nokia.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D9E4A63.007F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Apr 2011 15:27:46 +0300 Ameya Palande wrote:

> +- Support for extended (non-PC) x86 platform
>         |  +- AMD Elan
>         |  +- Moorestown MID platform
>         |  +- RDC R-321x SoC
>         |  +- Support non-standard 32-bit SMP architectures
>         |     +- NUMAQ (IBM/Sequent)
>         |     +- Summit/EXA (IBM x440)
> 
> Signed-off-by: Ameya Palande <ameya.palande@nokia.com>

Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>

Looks good.  Thanks.

> ---
>  arch/x86/Kconfig |  112 ++++++++++++++++++++++++++---------------------------
>  1 files changed, 55 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cc6c53a..6aaeb49 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -319,55 +319,12 @@ config X86_EXTENDED_PLATFORM
>  
>  	  If you have one of these systems, or if you want to build a
>  	  generic distribution kernel, say Y here - otherwise say N.
> -endif
> -
> -if X86_64
> -config X86_EXTENDED_PLATFORM
> -	bool "Support for extended (non-PC) x86 platforms"
> -	default y
> -	---help---
> -	  If you disable this option then the kernel will only support
> -	  standard PC platforms. (which covers the vast majority of
> -	  systems out there.)
> -
> -	  If you enable this option then you'll be able to select support
> -	  for the following (non-PC) 64 bit x86 platforms:
> -		ScaleMP vSMP
> -		SGI Ultraviolet
> -
> -	  If you have one of these systems, or if you want to build a
> -	  generic distribution kernel, say Y here - otherwise say N.
> -endif
> -# This is an alphabetically sorted list of 64 bit extended platforms
> -# Please maintain the alphabetic order if and when there are additions
> -
> -config X86_VSMP
> -	bool "ScaleMP vSMP"
> -	select PARAVIRT_GUEST
> -	select PARAVIRT
> -	depends on X86_64 && PCI
> -	depends on X86_EXTENDED_PLATFORM
> -	---help---
> -	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
> -	  supposed to run on these EM64T-based machines.  Only choose this option
> -	  if you have one of these machines.
> -
> -config X86_UV
> -	bool "SGI Ultraviolet"
> -	depends on X86_64
> -	depends on X86_EXTENDED_PLATFORM
> -	depends on NUMA
> -	depends on X86_X2APIC
> -	---help---
> -	  This option is needed in order to support SGI Ultraviolet systems.
> -	  If you don't have one of these, you should say N here.
>  
>  # Following is an alphabetically sorted list of 32 bit extended platforms
>  # Please maintain the alphabetic order if and when there are additions
>  
>  config X86_ELAN
>  	bool "AMD Elan"
> -	depends on X86_32
>  	depends on X86_EXTENDED_PLATFORM
>  	---help---
>  	  Select this for an AMD Elan processor.
> @@ -380,7 +337,6 @@ config X86_INTEL_CE
>  	bool "CE4100 TV platform"
>  	depends on PCI
>  	depends on PCI_GODIRECT
> -	depends on X86_32
>  	depends on X86_EXTENDED_PLATFORM
>  	select X86_REBOOTFIXUPS
>  	select OF
> @@ -394,7 +350,6 @@ config X86_MRST
>         bool "Moorestown MID platform"
>  	depends on PCI
>  	depends on PCI_GOANY
> -	depends on X86_32
>  	depends on X86_EXTENDED_PLATFORM
>  	depends on X86_IO_APIC
>  	select APB_TIMER
> @@ -412,7 +367,6 @@ config X86_MRST
>  
>  config X86_RDC321X
>  	bool "RDC R-321x SoC"
> -	depends on X86_32
>  	depends on X86_EXTENDED_PLATFORM
>  	select M486
>  	select X86_REBOOTFIXUPS
> @@ -423,7 +377,7 @@ config X86_RDC321X
>  
>  config X86_32_NON_STANDARD
>  	bool "Support non-standard 32-bit SMP architectures"
> -	depends on X86_32 && SMP
> +	depends on SMP
>  	depends on X86_EXTENDED_PLATFORM
>  	---help---
>  	  This option compiles in the NUMAQ, Summit, bigsmp, ES7000, default
> @@ -446,19 +400,10 @@ config X86_NUMAQ
>  	  of Flat Logical.  You will need a new lynxer.elf file to flash your
>  	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
>  
> -config X86_SUPPORTS_MEMORY_FAILURE
> -	def_bool y
> -	# MCE code calls memory_failure():
> -	depends on X86_MCE
> -	# On 32-bit this adds too big of NODES_SHIFT and we run out of page flags:
> -	depends on !X86_NUMAQ
> -	# On 32-bit SPARSEMEM adds too big of SECTIONS_WIDTH:
> -	depends on X86_64 || !SPARSEMEM
> -	select ARCH_SUPPORTS_MEMORY_FAILURE
>  
>  config X86_VISWS
>  	bool "SGI 320/540 (Visual Workstation)"
> -	depends on X86_32 && PCI && X86_MPPARSE && PCI_GODIRECT
> +	depends on PCI && X86_MPPARSE && PCI_GODIRECT
>  	depends on X86_32_NON_STANDARD
>  	---help---
>  	  The SGI Visual Workstation series is an IA32-based workstation
> @@ -482,6 +427,59 @@ config X86_ES7000
>  	---help---
>  	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
>  	  supposed to run on an IA32-based Unisys ES7000 system.
> +endif
> +
> +config X86_SUPPORTS_MEMORY_FAILURE
> +	def_bool y
> +	# MCE code calls memory_failure():
> +	depends on X86_MCE
> +	# On 32-bit this adds too big of NODES_SHIFT and we run out of page flags:
> +	depends on !X86_NUMAQ
> +	# On 32-bit SPARSEMEM adds too big of SECTIONS_WIDTH:
> +	depends on X86_64 || !SPARSEMEM
> +	select ARCH_SUPPORTS_MEMORY_FAILURE
> +
> +if X86_64
> +config X86_EXTENDED_PLATFORM
> +	bool "Support for extended (non-PC) x86 platforms"
> +	default y
> +	---help---
> +	  If you disable this option then the kernel will only support
> +	  standard PC platforms. (which covers the vast majority of
> +	  systems out there.)
> +
> +	  If you enable this option then you'll be able to select support
> +	  for the following (non-PC) 64 bit x86 platforms:
> +		ScaleMP vSMP
> +		SGI Ultraviolet
> +
> +	  If you have one of these systems, or if you want to build a
> +	  generic distribution kernel, say Y here - otherwise say N.
> +
> +# This is an alphabetically sorted list of 64 bit extended platforms
> +# Please maintain the alphabetic order if and when there are additions
> +
> +config X86_VSMP
> +	bool "ScaleMP vSMP"
> +	select PARAVIRT_GUEST
> +	select PARAVIRT
> +	depends on PCI
> +	depends on X86_EXTENDED_PLATFORM
> +	---help---
> +	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
> +	  supposed to run on these EM64T-based machines.  Only choose this option
> +	  if you have one of these machines.
> +
> +config X86_UV
> +	bool "SGI Ultraviolet"
> +	depends on X86_EXTENDED_PLATFORM
> +	depends on NUMA
> +	depends on X86_X2APIC
> +	---help---
> +	  This option is needed in order to support SGI Ultraviolet systems.
> +	  If you don't have one of these, you should say N here.
> +endif
> +
>  
>  config X86_32_IRIS
>  	tristate "Eurobraille/Iris poweroff module"
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
