Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0EJMeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:34:37 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:5628 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0EJMef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:34:35 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lab9bhzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L27EX1-02-008-02
X-M-MSG: 
Date: Mon, 10 May 2010 14:33:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: John Villalovos <sodarock@gmail.com>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: [PATCH V2] Oprofile: Change CPUIDS from decimal to hex, and
 add some comments
Message-ID: <20100510123352.GF6450@erda.amd.com>
References: <20100507164140.GA6128@linuxjohn.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100507164140.GA6128@linuxjohn.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.10 12:41:40, John Villalovos wrote:
> Version 2:
> 
> Incorporating suggested changes from Robert Richter.
> 
> Back when the patch was submitted for "Add Xeon 7500 series support to
> oprofile", Robert Richter had asked for a followon patch that converted all the
> CPU ID values to hex.
> 
> I have done that here for the "i386/core_i7" and "i386/atom" class
> processors in the ppro_init() function and also added some comments on
> where to find documentation on the Intel processors.
> 
> Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 9f001d9..2de5f44 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -586,6 +586,13 @@ static int __init ppro_init(char **cpu_type)
>  	if (force_arch_perfmon && cpu_has_arch_perfmon)
>  		return 0;
>  
> +	/* Documentation on identifying Intel processors by CPU Family and Model
> +	 * can be found in the Intel Software Developer's Manual (SDM).
> +	 * http://www.intel.com/products/processor/manuals/
> +	 * As of May 2010 the documentation for this was in the:
> +	 * "Intel 64 and IA-32 Architectures Software Developer's Manual Volume
> +	 * 3B: System Programming Guide",
> +	 * "Table B-1 CPUID Signature Values of DisplayFamily_DisplayModel" */
>  	switch (cpu_model) {
>  	case 0 ... 2:
>  		*cpu_type = "i386/ppro";

Patch applied, thanks John. I made some small style changes to your
comment:

       /*
        * Documentation on identifying Intel processors by CPU family
        * and model can be found in the Intel Software Developer's
        * Manuals (SDM):
        *
        *  http://www.intel.com/products/processor/manuals/
        *
        * As of May 2010 the documentation for this was in the:
        * "Intel 64 and IA-32 Architectures Software Developer's
        * Manual Volume 3B: System Programming Guide", "Table B-1
        * CPUID Signature Values of DisplayFamily_DisplayModel".
        */

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

