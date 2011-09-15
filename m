Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab1IOEQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 00:16:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36530 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1IOEQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 00:16:17 -0400
Message-ID: <4E717C0A.5050905@gmail.com>
Date: Wed, 14 Sep 2011 21:16:10 -0700
From: David Daney <david.s.daney@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Daney <david.daney@cavium.com>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        ralf@linux-mips.org
Subject: Re: [PATCH 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
References: <1314820906-14004-1-git-send-email-david.daney@cavium.com>        <1314820906-14004-3-git-send-email-david.daney@cavium.com> <CACxGe6tA6D9JVf0_K-JAGnKcQmDmD=1ytqqYb6or-KjP9uZNxg@mail.gmail.com>
In-Reply-To: <CACxGe6tA6D9JVf0_K-JAGnKcQmDmD=1ytqqYb6or-KjP9uZNxg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2011 05:51 PM, Grant Likely wrote:
>
>
> On Aug 31, 2011 2:01 PM, "David Daney" <david.daney@cavium.com 
> <mailto:david.daney@cavium.com>> wrote:
> >
> > This patch adds a somewhat generic framework for MDIO bus
> > multiplexers.  It is modeled on the I2C multiplexer.
> >
>
[...]
>
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/mdio-mux.txt
> > @@ -0,0 +1,132 @@
> > +Common MDIO bus multiplexer/switch properties.
> > +
> > +An MDIO bus multiplexer/switch will have several child busses that are
> > +numbered uniquely in a device dependent manner.  The nodes for an MDIO
> > +bus multiplexer/switch will have one child node for each child bus.
> > +
> > +Required properties:
> > +- parent-bus : phandle to the parent MDIO bus.
>
> As discussed, I like mdio-parent-bus.
>
> > +
> > +Optional properties:
> > +- Other properties specific to the multiplexer/switch hardware.
> > +
> > +Required properties for child nodes:
> > +- #address-cells = <1>;
> > +- #size-cells = <0>;
> > +- cell-index : The sub-bus number.
>
> Use reg, not cell-index. That is what it is there for. And add the 
> appropriate #address/size-cells in the parent.
>
> I've not reviewed the implementation, but with the changes. I'm okay 
> with the binding.
>

Thanks for the prompt reply Grant.

I will rework this with the binding changes and send a new version soon.

David Daney
