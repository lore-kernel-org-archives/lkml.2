Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935540Ab2JYNSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:18:51 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:22765 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759022Ab2JYNSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:18:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/EIoZxBI9XORoTKbjOGntkyV3waOLC7gY=
Date: Thu, 25 Oct 2012 09:18:18 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm: mvebu: adding SATA support: dt binding and
 config update
Message-ID: <20121025131818.GF18811@titan.lakedaemon.net>
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
 <1351086561-13569-3-git-send-email-gregory.clement@free-electrons.com>
 <20121024160139.6dbf5e16@skate>
 <5087F5B9.0@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5087F5B9.0@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 04:05:45PM +0200, Gregory CLEMENT wrote:
> On 10/24/2012 04:01 PM, Thomas Petazzoni wrote:
> > Hello,
> > 
> > Shouldn't you split into one commit adding the SATA definition in
> > the .dtsi + doing the defconfig change (the "SoC" level modifications),
> > and then another commit for the .dts change? I don't really care
> > personally, it's really up to Jason/Andrew on this.
> > 
> > Another comment below, though.
> > 
> > On Wed, 24 Oct 2012 15:49:21 +0200, Gregory CLEMENT wrote:
> > 
> >> diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
> >> index 94b4b9e..3f08233 100644
> >> --- a/arch/arm/boot/dts/armada-370-xp.dtsi
> >> +++ b/arch/arm/boot/dts/armada-370-xp.dtsi
> >> @@ -69,6 +69,16 @@
> >>  			compatible = "marvell,armada-addr-decoding-controller";
> >>  			reg = <0xd0020000 0x258>;
> >>  		};
> >> +
> >> +		sata@d00a0000 {
> >> +                        compatible = "marvell,orion-sata";
> >> +                        reg = <0xd00a0000 0x2400>;
> >> +                        interrupts = <55>;
> >> +                        nr-ports = <2>;
> >> +			clocks = <&coreclk 0>;//,  <&coreclk 0>;
> > 
> > Alignment problem + remainings of tests or something like that.
> 
> True I missed this one.
> 
> Jason, Andrew, do you want I split this patch as suggested by Thomas or
> are you fine with having one single patch?

Yes, please make the defconfig changes a separate patch.  Also, please
make sure only the minimum is enabled (eq RAID... isn't needed).

thx,

Jason.
