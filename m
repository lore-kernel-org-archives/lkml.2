Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1FZXVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 19:21:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38146 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab1FZXT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 19:19:26 -0400
Date: Sun, 26 Jun 2011 16:19:14 -0700 (PDT)
Message-Id: <20110626.161914.1023073148636112144.davem@davemloft.net>
To: jj@chaosbits.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au
Subject: Re: [PATCH] Crypto: Don't use err uninitialized in
 algif_hash.c:hash_sendmsg()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1106262320530.26572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106262320530.26572@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 26 Jun 2011 16:19:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 26 Jun 2011 23:23:06 +0200 (CEST)

> If af_alg_make_sg() returns <0 in hash_sendmsg() we'll jump to the
> 'unlock' label without having set 'err' to anything. At the 'unlock'
> label the value of 'err' is tested to determine return value of the
> function - not good to base that on a uninitialized variable.
> 
> This patch sets 'err' to the return value of hash_sendmsg() before the
> 'goto' when the value is less than zero, which seems to me to be the
> proper thing to do.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: David S. Miller <davem@davemloft.net>
