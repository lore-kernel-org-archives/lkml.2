Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232Ab2J2SBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:01:37 -0400
Received: from smtp121.dfw.emailsrvr.com ([67.192.241.121]:48638 "EHLO
	smtp121.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab2J2SBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:01:36 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2012 14:01:36 EDT
Message-ID: <508EC267.6020208@calxeda.com>
Date: Mon, 29 Oct 2012 12:52:39 -0500
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jonathan@jonmasters.org, eric.dumazet@gmail.com,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: Re: [PATCH 0/6] Calxeda xgmac performance fixes
References: <1350054908-30646-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1350054908-30646-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On 10/12/2012 10:15 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This is a series of performance improvements to the xgmac driver. The most
> significant changes are the alignment fixes to avoid alignment traps on
> received frames and using relaxed i/o accessors.

Can you please apply this series for 3.7. They are all self-contained to
the xgmac driver and fix some performance issues including unaligned
access traps in the IP stack. If 3.7 is not acceptable, then 3.8 is fine.

Note that only patch 5 has a v2 version.

Rob

> 
> Rob Herring (6):
>   net: calxedaxgmac: enable operate on 2nd frame mode
>   net: calxedaxgmac: remove explicit rx dma buffer polling
>   net: calxedaxgmac: use relaxed i/o accessors in rx and tx paths
>   net: calxedaxgmac: drop some unnecessary register writes
>   net: calxedaxgmac: rework transmit ring handling
>   net: calxedaxgmac: ip align receive buffers
> 
>  drivers/net/ethernet/calxeda/Kconfig |    2 +-
>  drivers/net/ethernet/calxeda/xgmac.c |   57 +++++++++++++++-------------------
>  2 files changed, 26 insertions(+), 33 deletions(-)
> 
