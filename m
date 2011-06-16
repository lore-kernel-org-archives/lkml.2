Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1FPO5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:57:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49527 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1FPO5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:57:02 -0400
Date: Thu, 16 Jun 2011 08:56:59 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 11/11] arm/versatile: Add device tree support
Message-ID: <20110616145659.GC3795@ponder.secretlab.ca>
References: <20110616042653.29371.2052.stgit@ponder>
 <20110616044311.29371.49018.stgit@ponder>
 <201106161620.37205.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106161620.37205.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 04:20:37PM +0200, Arnd Bergmann wrote:
> On Thursday 16 June 2011, Grant Likely wrote:
> > This patch adds a new versatile platform for when using the device
> > tree.  Add platform and amba devices are discovered and registered by
> > parsing the device tree.  Clocks and initial io mappings are still
> > configured statically.
> 
> Hi Grant,
> 
> Two small questions about the device tree contents:
> 
> > +       i2c@10002000 {
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +               compatible = "arm,versatile-i2c";
> > +               reg = <0x10002000 0x1000>;
> > +
> > +               rtc@68 {
> > +                       compatible = "dallas,ds1338";
> > +                       reg = <0x68>;
> > +               };
> > +       };
> > +
> > +       net@10010000 {
> > +               compatible = "smsc,lan91c111";
> > +               reg = <0x10010000 0x10000>;
> > +               interrupts = <25>;
> > +       };
> > +
> > +       lcd@10008000 {
> > +               compatible = "arm,versatile-lcd";
> > +               reg = <0x10008000 0x1000>;
> > +       };
> 
> Why are these devices on the top level, rather than on the AMBA bus or
> the FPGA? From the documentation, it seems that they are implemented
> in the FPGA, which would also match the address layout.

Mostly because I 'faked' this device tree based on what is currently
in the kernel for the Versatile platform.  I need to look at the
documentation and make it reflect reality, including setting up ranges
correctly (as you commented on below).

> 
> > +       amba {
> > +               compatible = "arm,amba-bus";
> > +               #address-cells = <1>;
> > +               #size-cells = <1>;
> > +               ranges;
> > +
> > +               vic: intc@10140000 {
> > +                       compatible = "arm,versatile-vic", "arm,vic";
> > +                       interrupt-controller;
> > +                       #interrupt-cells = <1>;
> > +                       reg = <0x10140000 0x1000>;
> > +               };
> > +
> 
> Why the empty ranges property? All device registers are based on 0x10000000,
> so I'd expect this to be described like that here.
> 
> 	Arnd
