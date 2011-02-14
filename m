Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1BNAzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 19:55:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36679
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289Ab1BNAzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 19:55:18 -0500
Date: Sun, 13 Feb 2011 16:55:54 -0800 (PST)
Message-Id: <20110213.165554.173868884.davem@davemloft.net>
To: jj@chaosbits.net
Cc: linux-kernel@vger.kernel.org, chas@cmf.nrl.navy.mil,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        nathan@traverse.com.au, dwmw2@infradead.org, treker@xrio.com
Subject: Re: [PATCH] ATM, Solos PCI ADSL2+: Don't deref NULL pointer if
 net_ratelimit() and alloc_skb() interact badly.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1102132142460.18930@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102132142460.18930@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 13 Feb 2011 21:49:32 +0100 (CET)

> If alloc_skb() fails to allocate memory and returns NULL then we want to 
> return -ENOMEM from drivers/atm/solos-pci.c::popen() regardless of the 
> value of net_ratelimit(). The way the code is today, we may not return if 
> net_ratelimit() returns 0, then we'll proceed to pass a NULL pointer to 
> skb_put() which will blow up in our face.
> This patch ensures that we always return -ENOMEM on alloc_skb() failure 
> and only let the dev_warn() be controlled by the value of net_ratelimit().
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
