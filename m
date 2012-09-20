Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2ITLki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:40:38 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:13409 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2ITLkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:40:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14654088"
Date: Thu, 20 Sep 2012 12:39:45 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Pawel Moll <pawel.moll@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
In-Reply-To: <1348135563.11116.94.camel@hornet>
Message-ID: <alpine.DEB.2.02.1209201235450.29232@kaball.uk.xensource.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com> <1348135563.11116.94.camel@hornet>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Pawel Moll wrote:
> Morning,
> 
> On Wed, 2012-09-19 at 18:44 +0100, Stefano Stabellini wrote:
> > +/dts-v1/;
> > +
> > +/include/ "skeleton.dtsi"
> 
> Any particular reason to include skeleton? And I think it would be
> better to use #address-cells = <2> and #size-cells = <2>, to be ready
> for LPAE addresses...

good idea


> > +/ {
> > +	model = "XENVM-4.2";
> > +	compatible = "xen,xenvm-4.2", "arm,vexpress";
> > +	interrupt-parent = <&gic>;
> > +
> > +	chosen {
> > +		bootargs = "earlyprintk console=hvc0 root=/dev/xvda init=/sbin/init";
> > +	};
> > +
> > +	cpus {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +
> > +		cpu@0 {
> > +			device_type = "cpu";
> > +			compatible = "arm,cortex-a15";
> > +			reg = <0>;
> > +		};
> > +	};
> > +
> > +	memory {
> 
> Formally, it should be memory@80000000, not that I have any strong
> feelings about it :-)

OK


> > +		device_type = "memory";
> > +		reg = <0x80000000 0x08000000>;
> > +	};
> > +
> > +	gic: interrupt-controller@2c001000 {
> > +		compatible = "arm,cortex-a9-gic";
> > +		#interrupt-cells = <3>;
> > +		#address-cells = <0>;
> > +		interrupt-controller;
> > +		reg = <0x2c001000 0x1000>,
> > +		      <0x2c002000 0x100>;
> > +	};
> > +
> > +	timer {
> > +		compatible = "arm,armv7-timer";
> > +		interrupts = <1 13 0xf08>,
> > +			     <1 14 0xf08>,
> > +			     <1 11 0xf08>,
> > +			     <1 10 0xf08>;
> > +	};
> > +
> > +	hypervisor {
> > +		compatible = "xen,xen-4.2", "xen,xen";
> > +		reg = <0xb0000000 0x20000>;
> > +		interrupts = <1 15 0xf08>;
> > +	};
> 
> Is this binding documented somewhere - I mean in
> Documentation/devicetree/bindings?

Yes, it is: Documentation/devicetree/bindings/arm/xen.txt
added by: http://marc.info/?l=linux-kernel&m=134790380030990&w=2


> > +	motherboard {
> > +		arm,v2m-memory-map = "rs1";
> > +		ranges = <0 0 0x08000000 0x04000000>,
> > +			 <1 0 0x14000000 0x04000000>,
> > +			 <2 0 0x18000000 0x04000000>,
> > +			 <3 0 0x1c000000 0x04000000>,
> > +			 <4 0 0x0c000000 0x04000000>,
> > +			 <5 0 0x10000000 0x04000000>;
> > +
> > +		interrupt-map-mask = <0 0 63>;
> > +		interrupt-map = <0 0  0 &gic 0  0 4>,
> > +				<0 0  1 &gic 0  1 4>,
> > +				<0 0  2 &gic 0  2 4>,
> > +				<0 0  3 &gic 0  3 4>,
> > +				<0 0  4 &gic 0  4 4>,
> > +				<0 0  5 &gic 0  5 4>,
> > +				<0 0  6 &gic 0  6 4>,
> > +				<0 0  7 &gic 0  7 4>,
> > +				<0 0  8 &gic 0  8 4>,
> > +				<0 0  9 &gic 0  9 4>,
> > +				<0 0 10 &gic 0 10 4>,
> > +				<0 0 11 &gic 0 11 4>,
> > +				<0 0 12 &gic 0 12 4>,
> > +				<0 0 13 &gic 0 13 4>,
> > +				<0 0 14 &gic 0 14 4>,
> > +				<0 0 15 &gic 0 15 4>,
> > +				<0 0 16 &gic 0 16 4>,
> > +				<0 0 17 &gic 0 17 4>,
> > +				<0 0 18 &gic 0 18 4>,
> > +				<0 0 19 &gic 0 19 4>,
> > +				<0 0 20 &gic 0 20 4>,
> > +				<0 0 21 &gic 0 21 4>,
> > +				<0 0 22 &gic 0 22 4>,
> > +				<0 0 23 &gic 0 23 4>,
> > +				<0 0 24 &gic 0 24 4>,
> > +				<0 0 25 &gic 0 25 4>,
> > +				<0 0 26 &gic 0 26 4>,
> > +				<0 0 27 &gic 0 27 4>,
> > +				<0 0 28 &gic 0 28 4>,
> > +				<0 0 29 &gic 0 29 4>,
> > +				<0 0 30 &gic 0 30 4>,
> > +				<0 0 31 &gic 0 31 4>,
> > +				<0 0 32 &gic 0 32 4>,
> > +				<0 0 33 &gic 0 33 4>,
> > +				<0 0 34 &gic 0 34 4>,
> > +				<0 0 35 &gic 0 35 4>,
> > +				<0 0 36 &gic 0 36 4>,
> > +				<0 0 37 &gic 0 37 4>,
> > +				<0 0 38 &gic 0 38 4>,
> > +				<0 0 39 &gic 0 39 4>,
> > +				<0 0 40 &gic 0 40 4>,
> > +				<0 0 41 &gic 0 41 4>,
> > +				<0 0 42 &gic 0 42 4>;
> > +	};
> > +};
> 
> You've lost me here... You have ranges and interrupt map, but don't
> include motherboard file. Is it a mistake? If not, you could remove the
> ranges and interrupt-map, but where do you get your peripherals from
> then?

There are no peripherals apart from the ones that are already described
here (timer, gic). All the peripherals that the guest sees are virtual
devices that show up on xenbus (a virtual bus). In order to initialize
xenbus, the guest only needs the hypervisor node.  So I'll remove the
ranges and interrupt-map.
