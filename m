Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1K3NoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:44:21 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:51102 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1K3NoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:44:18 -0500
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzBuK2T8UE=
X-RZG-CLASS-ID: mo00
Message-ID: <4ED6331E.6020005@hartkopp.net>
Date: Wed, 30 Nov 2011 14:43:58 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Joe Perches <joe@perches.com>, Urs Thuermann <urs.thuermann@volkswagen.de>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: Update logging style
References: <30551d0a6a0f7f7799a6981c81c770a528f430d2.1322592708.git.joe@perches.com> <4ED53B47.1030703@pengutronix.de>
In-Reply-To: <4ED53B47.1030703@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2011 21:06, Marc Kleine-Budde wrote:

> On 11/29/2011 07:54 PM, Joe Perches wrote:
>> Use pr_fmt, pr_<level> and pr_<level>_ratelimited.
>> Coalesce format strings.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
> 
> The banners will probably looking a bit different, but I think nobody is
> screen scraping that output :)
> 
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>



Nobody but me. Therefore it get's a NACK.

Indeed the banners are pretty broken now ...

Before:

can: controller area network core (rev 20090105 abi 8)
NET: Registered protocol family 29
can: raw protocol (rev 20090105)
can: netlink gateway (rev 20101209)
can: broadcast manager protocol (rev 20090105 t)

After Joe's patch:

can: controller area network core (rev 20090105 abi 8)
NET: Registered protocol family 29
can_raw: raw protocol (rev 20090105)
can_gw: netlink gateway (rev 20101209)
can_bcm: broadcast manager protocol (rev 20090105 t)

IMO if you want to use pr_fmt() it should at least look like this:

can: controller area network core (rev 20090105 abi 8)
NET: Registered protocol family 29
can_raw: can raw protocol (rev 20090105)
can_gw: can netlink gateway (rev 20101209)
can_bcm: can broadcast manager protocol (rev 20090105 t)

I'm fine with using pr_fmt() for error/warning output but not for the banner
in the currently suggested way.

Regards,
Oliver
