Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1GCSEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 14:04:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:38861 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab1GCSEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 14:04:10 -0400
In-Reply-To: <1309641352-18714-3-git-send-email-jonas@southpole.se>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se> <1309641352-18714-3-git-send-email-jonas@southpole.se>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <61570CA6-9450-4B9C-A472-FE62A5B23B49@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH v2 02/19] OpenRISC: Device tree
Date: Sun, 3 Jul 2011 20:07:45 +0200
To: Jonas Bonn <jonas@southpole.se>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The OpenRISC architecture uses the device tree infrastructure for the
> platform description.

Hurray, world domination is one step closer ;-)

> +	memory {
> +		device_type = "memory";
> +		reg = <0x00000000 0x8000000>;
> +	};

Might want to write this as 0x08000000 (easier to read).

> +	cpus {
> +		cpu@0 {

Any node with a textual unit address (@0) needs to have a "reg" property
with the same address (and then the parent node, "cpus", should have
#address-cells and #size-cells defined, probably to 1 and 0 resp. in  
this
case).

You can just name the node "cpu" here.

> +		pic: pic@0 {
> +			compatible = "opencores,or1k-pic";
> +			#interrupt-cells = <1>;
> +			interrupt-controller;
> +		};

Same thing here.  Although, does your interrupt controller have any  
registers?
You should describe them then.

> +
> +		serial0: serial@90000000 {
> +			/* FIXME: device_type is still needed here...
> +			   should remove requirement from of_serial driver */
> +			device_type = "serial";
> +			compatible = "opencores,uart", "ns16550a";

Opencores has and always will have only one UART implementation?  You  
should
make the "compatible" name more specific ("opencores,uart-16550a"  
perhaps).

> +		enet0: ethoc@92000000 {
> +			compatible = "opencores,ethoc", "ethoc";

Probably shouldn't have the "ethoc" there, way too generic a name.

> +			reg = <0x92000000 0x53>;

0x53?  Usually you write the size of the register block that is decoded,
not just the size of the defined registers; so it would be 0x100 or  
something
like that.


Segher

