Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0EOXlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 19:41:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:47459 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab0EOXlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 19:41:18 -0400
Subject: Re: [PATCH]460EX on-chip SATA driver <Kernel 2.6.33> <
 resubmission >
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linux-ide@vger.kernel.org, sr@denx.de,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <4BED8BF1.5080800@ru.mvista.com>
References: <201005051757.o45HvPmY005954@amcc.com>
	 <4BED8BF1.5080800@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 May 2010 09:40:28 +1000
Message-ID: <1273966828.21352.670.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 21:44 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Rupjyoti Sarmah wrote:
> 
> > This patch enables the on-chip DWC SATA controller of the AppliedMicro processor 460EX.
> >
> > Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com> 
> > Signed-off-by: Mark Miesfeld <mmiesfeld@appliedmicro.com>
> > Signed-off-by: Prodyut Hazarika <phazarika@appliedmicro.com>
> > ---
> >  arch/powerpc/boot/dts/canyonlands.dts |    8 +
> >  drivers/ata/Kconfig                   |    9 +
> >  drivers/ata/Makefile                  |    1 +
> >  drivers/ata/sata_dwc.c                | 1827 +++++++++++++++++++++++++++++++++
> >  4 files changed, 1845 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/ata/sata_dwc.c
> >
> > diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
> > index cd56bb5..d3b2c99 100644
> > --- a/arch/powerpc/boot/dts/canyonlands.dts
> > +++ b/arch/powerpc/boot/dts/canyonlands.dts
> > @@ -163,6 +163,14 @@
> >  			interrupts = <0x1e 4>;
> >  		};
> >  
> > +		SATA0: sata@bffd1000 {
> > +                        compatible = "amcc,sata-460ex";
> > +			reg = <4 0xbffd1000 0x800 4 0xbffd0800 0x400>;
> > +                        interrupt-parent = <&UIC3>;
> > +                        interrupts = <0x0 0x4       /* SATA */
> > +                                      0x5 0x4>;     /* AHBDMA */
> > +                };
> > +
> >  		POB0: opb {
> >  			compatible = "ibm,opb-460ex", "ibm,opb";
> >  			#address-cells = <1>;
> >   
> 
>    Please put the device tree update in a separate patch to go thru the 
> PowerPC tree.

Additionally, the boot wrapper should probably either remove the node or
at least use a status property "ok" / "disabled" to represent whether
the board is configured for SATA or PCIe x1...

Cheers,
Ben.


