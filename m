Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1JXWge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:36:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51106 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab1JXWgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:36:32 -0400
Date: Mon, 24 Oct 2011 18:36:23 -0400 (EDT)
Message-Id: <20111024.183623.551713905402332500.davem@davemloft.net>
To: jj@chaosbits.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sjur.brandeland@stericsson.com
Subject: Re: [PATCH] caif: fix cfcnfg_add_phy_layer() leaks
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1110242359160.19795@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1110242359160.19795@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 24 Oct 2011 15:36:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Tue, 25 Oct 2011 00:01:00 +0200 (CEST)

> There are two locations where we 'goto out' after having allocated
> memory for 'phyinfo' but have not yet assigned it to anything. At the
> 'out:' label we'll exit from the function and 'phyinfo' will go out of
> scope and thus we leak the memory we allocated.
> 
> This patch frees the memory before jumping to 'out:', thus fixing the
> leaks.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

The code in net-next looks a lot different, please see if the issue
still exists there and resubmit if so, thanks!
