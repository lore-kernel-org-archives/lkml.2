Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2GVVyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 17:54:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38943 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2GVVyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 17:54:08 -0400
Date: Sun, 22 Jul 2012 14:54:07 -0700 (PDT)
Message-Id: <20120722.145407.2163219263880320745.davem@davemloft.net>
To: jj@chaosbits.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix references to out-of-scope variables in
 put_cmsg_compat()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1207222335200.31033@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207222335200.31033@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 22 Jul 2012 23:37:20 +0200 (CEST)

> In net/compat.c::put_cmsg_compat() we may assign 'data' the address of
> either the 'ctv' or 'cts' local variables inside the 'if
> (!COMPAT_USE_64BIT_TIME)' branch.
> 
> Those variables go out of scope at the end of the 'if' statement, so
> when we use 'data' further down in 'copy_to_user(CMSG_COMPAT_DATA(cm),
> data, cmlen - sizeof(struct compat_cmsghdr))' there's no telling what
> it may be refering to - not good.
> 
> Fix the problem by simply giving 'ctv' and 'cts' function scope.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied and queued up for -stable, thanks.
