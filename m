Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab1FIW7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:59:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42574 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1FIW7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:59:47 -0400
Date: Thu, 09 Jun 2011 15:59:43 -0700 (PDT)
Message-Id: <20110609.155943.162785602513776337.davem@davemloft.net>
To: jj@chaosbits.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Sparc: Remove trigraph in die_if_kernel() message.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1106071627260.8844@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106071627260.8844@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 09 Jun 2011 15:59:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Tue, 7 Jun 2011 16:38:19 +0200 (CEST)

> In arch/sparc/kernel/traps_32.c::do_priv_instruction() we have this:
> 
>   die_if_kernel("Penguin instruction from Penguin mode??!?!", regs);
> 
> If I'm not mistaken, that "??!" will be taken as a trigraph for "|" by the 
> preprocessor, so the final string will end up either as
>   "Penguin instruction from Penguin mode|?!"
> which I assume is not what we want, or as the correct string but with a 
> warning about an ignored trigraph which I assume we don't want either. So, 
> in order to elliminate the trigraph but keep the original string intact I 
> changed it to
> 
>   die_if_kernel("Penguin instruction from Penguin mode?""?!?!", regs);
> 
> I've tested with a small test program on my x86-64 host and it behaves as 
> I would expect, but I've not tested the actual code in 
> arch/sparc/kernel/traps_32.c since I have no way to compile for sparc 
> (which is why I submit this as a [RFC] patch).
> 
> Please take a look and apply if you agree :-)
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks Jesper :-)
