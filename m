Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab2DYGoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 02:44:30 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:62210 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2DYGo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 02:44:28 -0400
Message-ID: <20375.40225.227084.644318@ipc1.ka-ro>
Date: Wed, 25 Apr 2012 08:43:45 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: viresh kumar <viresh.linux@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        sshtylyov@mvista.com, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        mturquette@linaro.org, akpm@linux-foundation.org, jgarzik@redhat.com,
        linux-arm-kernel@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 07/12] ata/sata_mv: Remove conditional compilation of
 clk code
In-Reply-To: <20120425052802.GF13489@lunn.ch>
References: <cover.1335266056.git.viresh.kumar@st.com>
	<abbcf661dc58948794839eb0fba1d5a0950ec848.1335266056.git.viresh.kumar@st.com>
	<20120424120019.GE24089@lunn.ch>
	<CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
	<20120424201802.GE3628@n2100.arm.linux.org.uk>
	<CAOh2x==Se4ipK_jexOE_=82=S4p41W9Ek0Om6DrUwctSz-Wcyw@mail.gmail.com>
	<20120425052802.GF13489@lunn.ch>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Lunn writes:
> > This is what i was thinking too and thats why floated this version of patch.
> > But as Andrew said, clk API support is enabled for them, but still they
> > don't have a clk for sata. To get this working, there are two solutions:
> > - Create dummy clk for sata for that platform, so clk_get doesn't fail.
> > - Check for error before every call to clk APIs after clk_get().
> > 
> > Andrew favored the second one. Which means, even on platforms
> > with clk API defined and clk enable required, if there are some issues
> > with lookup table, and clk_get() fails, system may hang when registers
> > are accessed. For this i favored first one.
> 
> I'm not too sure how you are going to achieve 1)
> 
> config SATA_MV
>         tristate "Marvell SATA support"
>         help
>           This option enables support for the Marvell Serial ATA family.
>           Currently supports 88SX[56]0[48][01] PCI(-X) chips,
>           as well as the newer [67]042 PCI-X/PCIe and SOC devices.
> 
> So this driver can be used with anything which has a PCI(-X) or PCIe
> bus, or Orion SoC and a few PowerPC SoCs.
> 
> The SoCs are not too bad, we know which ones they are and we can add
> dummy entries to their device tree. However, how do you want to handle
> the PCI devices? Create the dummy entry somewhere in the middle of the
> PCI core?
> 
> Thought not.
> 
AFAICT the PCI archs do not have HAVE_CLK enabled. Thus they will have
a dummy clk API in place that provides the driver with a non-error
clk_get() return value.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
