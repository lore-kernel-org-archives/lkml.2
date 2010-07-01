Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab0GAEJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 00:09:05 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:10359 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718Ab0GAEJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 00:09:03 -0400
Message-ID: <000401cb18d3$22f6d940$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Andy Isaacson" <adi@hexapodia.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Wang, Yong Y" <yong.y.wang@intel.com>,
       "Wang Qi" <qi.wang@intel.com>, "Intel OTC" <joel.clark@intel.com>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <4C204B0D.2030201@dsn.okisemi.com> <20100629233111.GA6357@hexapodia.org> <000301cb1819$439924b0$66f8800a@maildom.okisemi.com> <20100630182829.GJ29166@hexapodia.org>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Thu, 1 Jul 2010 13:08:59 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

> 1. When writing comments, do not write comments that duplicate the code.
> Instead of writing
Our Phub patch I have resubmitted yesterday have been already modified above.

> 2. your register names are very long.  Since the #define names are
> private to this driver, there's no need to make them extremely
> descriptive.  Instead of naming your registers
> PCH_PHUB_PHUB_ID_REG, you should change the names to be shorter, like
> PHUB_ID_REG or PCH_ID_REG.  This will make your source code much more
> readable by reducing linewrapping.
This was our mistake.
I have modified PCH_PHUB_PHUB_ID_REG to PCH_PHUB_ID_REG.
Our Phub patch I have resubmitted yesterday have been already modified above.

> It sounds like PHUB is a system-level device which provides access to a
> SROM which contains GbE configuration data.  If that is correct, then I
> have two comments:
Yes, SROM has GbE configuration data (GbE mac address) .

>
> 1.  There are many other systems with similar configurations -- MIPS
> SiByte, Alpha SRM, SPARC OpenFirmware, and some ARM systems, just to
> name a few.  None of them expose the SROM as a custom /dev node AFAIK.
> Is there a shared infrastructure that you can implement?
Sorry, I can't understand your intension.
Please give me more detail.

>
> 2. How does your GbE driver get the MAC address from the SPROM?  If
> there is an in-kernel user of the PHUB interface, it might be much
> easier to understand the design.
PHUB HW transfers MAC address(in SROM) data to GbE register to set MAC address when boot processing.

Thanks, Ohtake
----- Original Message ----- 
From: "Andy Isaacson" <adi@hexapodia.org>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>; "Wang, Yong Y" <yong.y.wang@intel.com>; "Wang Qi" <qi.wang@intel.com>; "Intel OTC"
<joel.clark@intel.com>; "Andrew" <andrew.chih.howe.khor@intel.com>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>; "LKML"
<linux-kernel@vger.kernel.org>
Sent: Thursday, July 01, 2010 3:28 AM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> On Wed, Jun 30, 2010 at 02:58:25PM +0900, Masayuki Ohtake wrote:
> > > > + unsigned int i;
> > > > + void __iomem *p = pch_phub_reg.pch_phub_base_address;
> > > > +
> > > > + dev_dbg(&pdev->dev, "pch_phub_restore_reg_conf ENTRY\n");
> > > > + /* to store contents of PHUB_ID register */
> > > > + iowrite32(pch_phub_reg.phub_id_reg, p + PCH_PHUB_PHUB_ID_REG);
> > >
> > > Don't include comments that just duplicate the code.  Also, rename your
> > > constants from PCH_PHUB_PHUB_ to, I dunno, PHUB_ or something.
> >
> > Sorry, I can't understand your intention.
> > Please give us more information.
>
> My mistake, I merged two comments into one paragraph, let me clarify.
>
> 1. When writing comments, do not write comments that duplicate the code.
> Instead of writing
> /* store PHUB_ID */
> iowrite32(..._PHUB_ID_REG);
> /* store PHUB_FOO */
> iowrite32(..._PHUB_FOO_REG);
> you should delete the line-by-line comments and just write
> iowrite32(..._PHUB_ID_REG);
> iowrite32(..._PHUB_FOO_REG);
>
> 2. your register names are very long.  Since the #define names are
> private to this driver, there's no need to make them extremely
> descriptive.  Instead of naming your registers
> PCH_PHUB_PHUB_ID_REG, you should change the names to be shorter, like
> PHUB_ID_REG or PCH_ID_REG.  This will make your source code much more
> readable by reducing linewrapping.
>
> > > I seriously doubt that your device is special enough to warrant a custom
> > > /dev node with proprietary semantics.  If this is just part of an
> > > Ethernet driver, please implement it in drivers/net/; if this is a
> > > generic PROM accessor, there must be some semi-standardized EPROM access
> > > interface but I don't know what it is offhand.
> >
> > Since SROM is not in GbE HW but Phub HW, Phub is not part of Ethernet driver.
> > Packet hub is not generic driver but special device.
>
> It sounds like PHUB is a system-level device which provides access to a
> SROM which contains GbE configuration data.  If that is correct, then I
> have two comments:
>
> 1.  There are many other systems with similar configurations -- MIPS
> SiByte, Alpha SRM, SPARC OpenFirmware, and some ARM systems, just to
> name a few.  None of them expose the SROM as a custom /dev node AFAIK.
> Is there a shared infrastructure that you can implement?
>
> 2. How does your GbE driver get the MAC address from the SPROM?  If
> there is an in-kernel user of the PHUB interface, it might be much
> easier to understand the design.
>
> Thanks for responding to my review so quickly!
> -andy
>



