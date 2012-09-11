Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2IKWXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:23:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43731 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2IKWXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:23:23 -0400
Message-ID: <504FB9D7.3030205@wwwdotorg.org>
Date: Tue, 11 Sep 2012 16:23:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 6/9] ARM: mvebu: add pinctrl device in DT for Armada
 370/XP SoCs
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1347266386-16229-7-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 02:39 AM, Sebastian Hesselbarth wrote:
> From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> The Armada 370 and XP SoCs have configurable muxing for a certain
> number of their pins, controlled through a pinctrl driver.

Hmmm. I'd be tempted just to put the entire node definition there;
putting in a .dtsi file just to share the reg property doesn't seem
especially useful.

> The 'compatible' property is defined in the SoC-specific .dtsi files,
> since the compatible string identifies the number of pins and other
> SoC-specific properties.

> diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi

> +		pinctrl@d0018000 {

If this is the only pinctrl instance, you'd typically name the node just
"pinctrl", since the "@d0018000" isn't needed to get unique node names.

> +			reg = <0xd0018000 0x38>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;

What is "ranges" for; this isn't a memory-mapped bus, right?

> +		};
>  	};
>  };

