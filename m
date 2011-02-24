Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1BXHux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 02:50:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57197
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387Ab1BXHuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 02:50:52 -0500
Date: Wed, 23 Feb 2011 23:51:29 -0800 (PST)
Message-Id: <20110223.235129.02262510.davem@davemloft.net>
To: ratbert.chuang@gmail.com
Cc: mirqus@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, joe@perches.com,
        dilinger@queued.net, ratbert@faraday-tech.com
Subject: Re: [PATCH v4] net: add Faraday FTMAC100 10/100 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimorcNAEbSpuE_dUXKuOBZDcDcGSJ2cGefniThc@mail.gmail.com>
References: <AANLkTikgDsM15DO7u2SP15xx=Y_pg6JdCLrie8ACobJP@mail.gmail.com>
	<20110131.203556.193730771.davem@davemloft.net>
	<AANLkTimorcNAEbSpuE_dUXKuOBZDcDcGSJ2cGefniThc@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 24 Feb 2011 15:27:55 +0800

> I guess the problem is because a HW restriction that the rx buffer must be
> 64 bits aligned. Since I cannot make rx buffer starts at offset 2 bytes, the
> IP header, TCP header and data are not 4 bytes aligned. The performance
> drops drastically.

I cannot believe that after 20 years of commodity ethernet networking
chips were first designed, people are still designing hardware that
doesn't do this right.

Just emit garbage bytes into the sub-word alignment padding if the chip
wants to word align it's DMA writes.

Even the 15 year old Dec Tulip chips do this properly.

