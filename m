Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab2JSKCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:02:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38731 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab2JSKCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:02:49 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH v2] arm/dts: AM33XX: Add SPI device tree data
Thread-Topic: [PATCH v2] arm/dts: AM33XX: Add SPI device tree data
Thread-Index: AQHNlWGG1yNOfoKWN0C6qlsopGsCgpfAH0mAgABx9NA=
Date: Fri, 19 Oct 2012 10:01:39 +0000
Deferred-Delivery: Fri, 19 Oct 2012 10:01:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9D18C6@DBDE01.ent.ti.com>
References: <1347946228-25874-1-git-send-email-avinashphilip@ti.com>
 <50810E2F.5@ti.com>
In-Reply-To: <50810E2F.5@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 13:54:15, Cousson, Benoit wrote:
> Hi Avinash,
> 
> This look good to me except the: status = "disabled".

status = "disabled" in soc .dtsi  file to make sure that IP driver
won't loaded unless if IP used. 
So from board .dts file status = "okay" should be set if IP being used.

Follows the uart1 case in AM33xx dtsi.

uart1 also sets status = "disabled"; in am33xx.dtsi & set status = "okay";
in am335x-evm.dts.

Thanks
Avinash

> 
> The "disabled" should be reserved for variant that does not contain the IP.
> Is it the case here?
> 
> Regards,
> Benoit
> 
> On 09/18/2012 07:30 AM, Philip, Avinash wrote:
> > Add McSPI data node to AM33XX device tree file. The McSPI module (and so
> > as the driver) is reused from OMAP4.
> > 
> > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> > Tested-by: Matt Porter <mporter@ti.com>
> > ---
> > Changes since v1:
> >         - Corrected reg offset in reg DT entry.
> > 
> > :100644 100644 ff3badb... 065fd54... M	arch/arm/boot/dts/am33xx.dtsi
> >  arch/arm/boot/dts/am33xx.dtsi |   25 +++++++++++++++++++++++++
> >  1 files changed, 25 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> > index ff3badb..065fd54 100644
> > --- a/arch/arm/boot/dts/am33xx.dtsi
> > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > @@ -219,5 +219,30 @@
> >  			interrupt-parent = <&intc>;
> >  			interrupts = <91>;
> >  		};
> > +
> > +		spi0: spi@48030000 {
> > +			compatible = "ti,omap4-mcspi";
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +			reg = <0x48030000 0x400>;
> > +			interrupt-parent = <&intc>;
> > +			interrupt = <65>;
> > +			ti,spi-num-cs = <2>;
> > +			ti,hwmods = "spi0";
> > +			status = "disabled";
> > +
> > +		};
> > +
> > +		spi1: spi@481a0000 {
> > +			compatible = "ti,omap4-mcspi";
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +			reg = <0x481a0000 0x400>;
> > +			interrupt-parent = <&intc>;
> > +			interrupt = <125>;
> > +			ti,spi-num-cs = <2>;
> > +			ti,hwmods = "spi1";
> > +			status = "disabled";
> > +		};
> >  	};
> >  };
> > 
> 
> 

