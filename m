Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1IIXWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:22:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55713 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1IIXWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <1314820906-14004-3-git-send-email-david.daney@cavium.com>
References: <1314820906-14004-1-git-send-email-david.daney@cavium.com>
	<1314820906-14004-3-git-send-email-david.daney@cavium.com>
Date: Fri, 9 Sep 2011 18:22:32 -0500
Message-ID: <CAKWjMd7pa=BikH0VkUZEFZ9yH+g6g9RSus9woqs1hbR+rb3u9A@mail.gmail.com>
Subject: Re: [PATCH 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
From: Andy Fleming <afleming@gmail.com>
To: David Daney <david.daney@cavium.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 3:01 PM, David Daney <david.daney@cavium.com> wrote:
> This patch adds a somewhat generic framework for MDIO bus
> multiplexers.  It is modeled on the I2C multiplexer.
>
> The multiplexer is needed if there are multiple PHYs with the same
> address connected to the same MDIO bus adepter, or if there is
> insufficient electrical drive capability for all the connected PHY
> devices.
>
> Conceptually it could look something like this:
>
>                   ------------------
>                   | Control Signal |
>                   --------+---------
>                           |
>  ---------------   --------+------
>  | MDIO MASTER |---| Multiplexer |
>  ---------------   --+-------+----
>                     |       |
>                     C       C
>                     h       h
>                     i       i
>                     l       l
>                     d       d
>                     |       |
>     ---------       A       B   ---------
>     |       |       |       |   |       |
>     | PHY@1 +-------+       +---+ PHY@1 |
>     |       |       |       |   |       |
>     ---------       |       |   ---------
>     ---------       |       |   ---------
>     |       |       |       |   |       |
>     | PHY@2 +-------+       +---+ PHY@2 |
>     |       |                   |       |
>     ---------                   ---------
>
> This framework configures the bus topology from device tree data.  The
> mechanics of switching the multiplexer is left to device specific
> drivers.
>
> The follow-on patch contains a multiplexer driven by GPIO lines.


It's amazing how various companies' board designers have come up with
the same brain-dead PHY topologies. We (Freescale) have some similar
code in our tree, but it's not this generically applicable.

>
> Signed-off-by: David Daney <david.daney@cavium.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: "David S. Miller" <davem@davemloft.net>

Looks good to me.

Acked-by: Andy Fleming <afleming@freescale.com>
