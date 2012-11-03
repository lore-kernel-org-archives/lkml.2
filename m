Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763285Ab2KCBhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 21:37:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49322 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763116Ab2KCBhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 21:37:01 -0400
Date: Fri, 02 Nov 2012 21:36:59 -0400 (EDT)
Message-Id: <20121102.213659.999845508936675142.davem@davemloft.net>
To: peter.senna@gmail.com
Cc: srinivas.kandagatla@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/net/phy/mdio-bitbang.c: Call
 mdiobus_unregister before mdiobus_free
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351440721-9121-2-git-send-email-peter.senna@gmail.com>
References: <1351440721-9121-1-git-send-email-peter.senna@gmail.com>
	<1351440721-9121-2-git-send-email-peter.senna@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>
Date: Sun, 28 Oct 2012 17:12:01 +0100

> Based on commit b27393aecf66199f5ddad37c302d3e0cfadbe6c0
> 
> Calling mdiobus_free without calling mdiobus_unregister causes
> BUG_ON(). This patch fixes the issue.
> 
> The semantic patch that found this issue(http://coccinelle.lip6.fr/):
> // <smpl>
> @@
> expression E;
> @@
>   ... when != mdiobus_unregister(E);
> 
> + mdiobus_unregister(E);
>   mdiobus_free(E);
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied.
