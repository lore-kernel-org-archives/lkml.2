Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab0F3S2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:28:31 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:40939 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab0F3S23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:28:29 -0400
Date: Wed, 30 Jun 2010 11:28:29 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Wang, Yong Y" <yong.y.wang@intel.com>,
       Wang Qi <qi.wang@intel.com>, Intel OTC <joel.clark@intel.com>,
       Andrew <andrew.chih.howe.khor@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Message-ID: <20100630182829.GJ29166@hexapodia.org>
References: <4C204B0D.2030201@dsn.okisemi.com> <20100629233111.GA6357@hexapodia.org> <000301cb1819$439924b0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301cb1819$439924b0$66f8800a@maildom.okisemi.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 02:58:25PM +0900, Masayuki Ohtake wrote:
> > > + unsigned int i;
> > > + void __iomem *p = pch_phub_reg.pch_phub_base_address;
> > > +
> > > + dev_dbg(&pdev->dev, "pch_phub_restore_reg_conf ENTRY\n");
> > > + /* to store contents of PHUB_ID register */
> > > + iowrite32(pch_phub_reg.phub_id_reg, p + PCH_PHUB_PHUB_ID_REG);
> >
> > Don't include comments that just duplicate the code.  Also, rename your
> > constants from PCH_PHUB_PHUB_ to, I dunno, PHUB_ or something.
> 
> Sorry, I can't understand your intention.
> Please give us more information.

My mistake, I merged two comments into one paragraph, let me clarify.

1. When writing comments, do not write comments that duplicate the code.
Instead of writing
	/* store PHUB_ID */
	iowrite32(..._PHUB_ID_REG);
	/* store PHUB_FOO */
	iowrite32(..._PHUB_FOO_REG);
you should delete the line-by-line comments and just write
	iowrite32(..._PHUB_ID_REG);
	iowrite32(..._PHUB_FOO_REG);

2. your register names are very long.  Since the #define names are
private to this driver, there's no need to make them extremely
descriptive.  Instead of naming your registers 
PCH_PHUB_PHUB_ID_REG, you should change the names to be shorter, like
PHUB_ID_REG or PCH_ID_REG.  This will make your source code much more
readable by reducing linewrapping.

> > I seriously doubt that your device is special enough to warrant a custom
> > /dev node with proprietary semantics.  If this is just part of an
> > Ethernet driver, please implement it in drivers/net/; if this is a
> > generic PROM accessor, there must be some semi-standardized EPROM access
> > interface but I don't know what it is offhand.
>
> Since SROM is not in GbE HW but Phub HW, Phub is not part of Ethernet driver.
> Packet hub is not generic driver but special device.

It sounds like PHUB is a system-level device which provides access to a
SROM which contains GbE configuration data.  If that is correct, then I
have two comments:

1.  There are many other systems with similar configurations -- MIPS
SiByte, Alpha SRM, SPARC OpenFirmware, and some ARM systems, just to
name a few.  None of them expose the SROM as a custom /dev node AFAIK.
Is there a shared infrastructure that you can implement?

2. How does your GbE driver get the MAC address from the SPROM?  If
there is an in-kernel user of the PHUB interface, it might be much
easier to understand the design.

Thanks for responding to my review so quickly!
-andy
