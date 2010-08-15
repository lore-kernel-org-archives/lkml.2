Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0HOFiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:38:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59159
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753315Ab0HOFiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:38:12 -0400
Date: Sat, 14 Aug 2010 22:38:30 -0700 (PDT)
Message-Id: <20100814.223830.200386282.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: kronos.it@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [xfrm_user] BUG: sleeping function called from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100813153658.GA27982@gondor.apana.org.au>
References: <20100812125027.GA12982@nb-core2.darkstar.lan>
	<20100813153658.GA27982@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 13 Aug 2010 11:36:58 -0400

> Luca Tettamanti <kronos.it@gmail.com> wrote:
>>
>> xfrm_user_policy takes read_lock(&xfrm_km_lock) before calling
>> xfrm_compile_policy (via km->compile_policy), which in turn calls
>> xfrm_policy_alloc with GFP_KERNEL.
> 
> Thanks for discovering this bug, it only took 8 years :)

We stumble over one of these every so often don't we? :)

> 
> xfrm: Use GFP_ATOMIC in xfrm_compile_policy
> 
> As xfrm_compile_policy runs within a read_lock, we cannot use
> GFP_KERNEL for memory allocations.
> 
> Reported-by: Luca Tettamanti <kronos.it@gmail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert.
