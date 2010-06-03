Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab0FCIdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:33:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35010 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab0FCIda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :organization:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=GQNGP7PS34SqA9mEo0lMo3TSRrC1g7kuiC497zsryMZ57fJJGuS2rbr06O3MGkmd2Y
         oTbNdI/o5UrUbwawk5DA5LJTmwMF65pP5e+CH6LI+7NtC23rUVIzzLQ8uCkpCeWR6t36
         agFE0SqXtOC7Wzmo7txaVCApCINTfwst0CXkc=
From: Florian Fainelli <florian@openwrt.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3] x86: CPU detection for RDC System-on-Chip
Date: Thu, 3 Jun 2010 10:32:12 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-server; KDE/4.4.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
       "linux-kernel" <linux-kernel@vger.kernel.org>, andi@firstfloor.org
References: <201005161455.34100.florian@openwrt.org> <201005190927.14385.florian@openwrt.org> <201005201658.49187.florian@openwrt.org>
In-Reply-To: <201005201658.49187.florian@openwrt.org>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006031032.12609.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 May 2010 16:58:48 Florian Fainelli wrote:
> On Wednesday 19 May 2010 09:27:12 Florian Fainelli wrote:
> > From: Mark Kelly <mark@bifferos.com>
> > 
> > The RDC System-on-Chip i486 compatible core does not support the cpuid
> > instruction and specific detection logic is required for this chip. The
> > patch below adds proper vendor and SoC type detection.
> 
> Is this version acceptable like it is now?

Ping? Anything that should be reworked?

Thank you.

> 
> Thank you for your answer.
> 
> > Signed-off-by: Mark Kelly <mark@bifferos.com>
> > Tested-by: Florian Fainelli <florian@openwrt.org>
> > ---
> > Changes from v3:
> > - read vendor and device id with a single 32-bits read
> > 
> > Changes from v2:
> > - change report url to bugzilla.kernel.org
> > - set vendor name to RDC even if customer id is not known
> > 
> > diff --git a/Documentation/x86/rdc.txt b/Documentation/x86/rdc.txt
> > new file mode 100644
> > index 0000000..f3dc7cf
> > --- /dev/null
> > +++ b/Documentation/x86/rdc.txt
> > @@ -0,0 +1,67 @@
> > +
> > +Introduction
> > +============
> > +
> > +RDC (http://www.rdc.com.tw) have been manufacturing x86-compatible SoC
> > +(system-on-chips) for a number of years.  They are not the fastest of
> > +CPUs (clock speeds ranging from 133-150MHz) but 486SX compatibility
> > +coupled with very low power consumption[1] and low cost make them ideal
> > +for embedded applications.
> > +
> > +
> > +Where to find
> > +=============
> > +
> > +RDC chips show up in numerous embedded devices, but be careful since
> > +many of them will not run Linux 2.6 without significant expertise.
> > +
> > +There are several variants of what the linux kernel refers to
> > generically +as RDC321X:  R8610, R321x, S3282 and AMRISC20000.
> > +
> > +R321x: Found in various routers, see the OpenWrt project for details,
> > +   http://wiki.openwrt.org/oldwiki/rdcport
> > +
> > +R8610: Found on the RDC evaluation board
> > +   http://www.ivankuten.com/system-on-chip-soc/rdc-r8610/
> > +
> > +AMRISC20000: Found in the MGB-100 wireless hard disk
> > +   http://tintuc.no-ip.com/linux/tipps/mgb100/
> > +
> > +S3282: Found in various NAS devices, including the Bifferboard
> > +   http://www.bifferos.com
> > +
> > +
> > +Kernel Configuration
> > +====================
> > +
> > +Add support for this CPU with CONFIG_X86_RDC321X.  Ensure that maths
> > +emulation is included (CONFIG_MATH_EMULATION selected) and avoid MCE
> > +(CONFIG_X86_MCE not selected).
> > +
> > +
> > +CPU detection
> > +=============
> > +
> > +None of these chips support the cpuid instruction, so as with some
> > +other x86 compatible SoCs, we must check the north bridge and look
> > +for specific 'signature' PCI device config.
> > +
> > +If you run a kernel on an unsupported customer id device, please file
> > +a bug with your customer id to: http://bugzilla.kernel.org/.
> > +
> > +Credits
> > +=======
> > +
> > +Many thanks to RDC for providing the customer codes to allow
> > +detection of all known variants, without which this detection code
> > +would have been very hard to ascertain.
> > +
> > +
> > +References
> > +==========
> > +
> > +[1] S3282 in certain NAS solutions consumes less than 1W
> > +
> > +
> > +mark@bifferos.com 2009
> > +
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 39e8e10..21b02f2 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -419,6 +419,7 @@ config X86_RDC321X
> > 
> >  	bool "RDC R-321x SoC"
> >  	depends on X86_32
> >  	depends on X86_EXTENDED_PLATFORM
> > 
> > +	select PCI
> > 
> >  	select M486
> >  	select X86_REBOOTFIXUPS
> >  	---help---
> > 
> > diff --git a/arch/x86/include/asm/processor.h
> > b/arch/x86/include/asm/processor.h index 5a51379..eddf979 100644
> > --- a/arch/x86/include/asm/processor.h
> > +++ b/arch/x86/include/asm/processor.h
> > @@ -122,7 +122,8 @@ struct cpuinfo_x86 {
> > 
> >  #define X86_VENDOR_CENTAUR	5
> >  #define X86_VENDOR_TRANSMETA	7
> >  #define X86_VENDOR_NSC		8
> > 
> > -#define X86_VENDOR_NUM		9
> > +#define X86_VENDOR_RDC		9
> > +#define X86_VENDOR_NUM		10
> > 
> >  #define X86_VENDOR_UNKNOWN	0xff
> > 
> > diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> > index 3a785da..af2d4a6 100644
> > --- a/arch/x86/kernel/cpu/Makefile
> > +++ b/arch/x86/kernel/cpu/Makefile
> > @@ -25,6 +25,7 @@ obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
> > 
> >  obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
> >  obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
> >  obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
> > 
> > +obj-$(CONFIG_X86_RDC321X)		+= rdc.o
> > 
> >  obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
> > 
> > diff --git a/arch/x86/kernel/cpu/rdc.c b/arch/x86/kernel/cpu/rdc.c
> > new file mode 100644
> > index 0000000..c2bcdcc
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/rdc.c
> > @@ -0,0 +1,73 @@
> > +/*
> > + * See Documentation/x86/rdc.txt
> > + *
> > + * mark@bifferos.com
> > + */
> > +
> > +#include <linux/pci.h>
> > +#include <asm/pci-direct.h>
> > +#include "cpu.h"
> > +
> > +
> > +static void __cpuinit rdc_identify(struct cpuinfo_x86 *c)
> > +{
> > +	u32 id;
> > +	u16 vendor, device;
> > +	u32 customer_id;
> > +
> > +	if (!early_pci_allowed())
> > +		return;
> > +
> > +	/* RDC CPU is SoC (system-on-chip), Northbridge is always present */
> > +	id = read_pci_config(0, 0, 0, PCI_VENDOR_ID);
> > +	vendor = id & 0xffff;
> > +	device = (id >> 16) & 0xffff;
> > +
> > +	if (vendor != PCI_VENDOR_ID_RDC || device != 
PCI_DEVICE_ID_RDC_R6020)
> > +		return;  /* not RDC */
> > +	/*
> > +	 * NB: We could go on and check other devices, e.g. r6040 NIC, but
> > +	 * that's probably overkill
> > +	 */
> > +
> > +	customer_id = read_pci_config(0, 0, 0, 0x90);
> > +
> > +	switch (customer_id) {
> > +		/* id names are from RDC */
> > +	case 0x00321000:
> > +		strcpy(c->x86_model_id, "R3210/R3211");
> > +		break;
> > +	case 0x00321001:
> > +		strcpy(c->x86_model_id, "AMITRISC20000/20010");
> > +		break;
> > +	case 0x00321002:
> > +		strcpy(c->x86_model_id, "R3210X/Edimax");
> > +		break;
> > +	case 0x00321003:
> > +		strcpy(c->x86_model_id, "R3210/Kcodes");
> > +		break;
> > +	case 0x00321004:  /* tested */
> > +		strcpy(c->x86_model_id, "S3282/CodeTek");
> > +		break;
> > +	case 0x00321007:
> > +		strcpy(c->x86_model_id, "R8610");
> > +		break;
> > +	default:
> > +		pr_info("RDC CPU: Unrecognised Customer ID (0x%x) please "
> > +			"report to: http://bugzilla.kernel.org/\n",
> > +			customer_id);
> > +		break;
> > +	}
> > +
> > +	strcpy(c->x86_vendor_id, "RDC");
> > +	c->x86_vendor = X86_VENDOR_RDC;
> > +}
> > +
> > +static const struct cpu_dev __cpuinitconst rdc_cpu_dev = {
> > +	.c_vendor	= "RDC",
> > +	.c_ident	= { "RDC" },
> > +	.c_identify	= rdc_identify,
> > +	.c_x86_vendor	= X86_VENDOR_RDC,
> > +};
> > +
> > +cpu_dev_register(rdc_cpu_dev);
