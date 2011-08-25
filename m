Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1HYCpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:45:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48037 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1HYCpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:45:39 -0400
Date: Wed, 24 Aug 2011 19:45:25 -0700 (PDT)
Message-Id: <20110824.194525.2193895272175663670.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: linux-kernel@vger.kernel.org, dgoulet@ev0ke.net,
        penguin-kernel@I-love.SAKURA.ne.jp, anton@samba.org, stable@kernel.org
Subject: Re: [PATCH 3.1-rc3/3.0.3] sendmmsg/sendmsg: fix unsafe user
 pointer access
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110825023940.GA23683@Krystal>
References: <20110825023940.GA23683@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 24 Aug 2011 19:45:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 24 Aug 2011 22:39:40 -0400

> Dereferencing a user pointer directly from kernel-space without going
> through the copy_from_user family of functions is a bad idea. Two of
> such usages can be found in the sendmsg code path called from sendmmsg,
> added by
> 
> commit c71d8ebe7a4496fb7231151cb70a6baa0cb56f9a upstream.
> commit 5b47b8038f183b44d2d8ff1c7d11a5c1be706b34 in the 3.0-stable tree.
> 
> Usages are performed through memcmp() and memcpy() directly. Fix those
> by using the already copied msg_sys structure instead of the __user *msg
> structure. Note that msg_sys can be set to NULL by verify_compat_iovec()
> or verify_iovec(), which requires additional NULL pointer checks.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: David Goulet <dgoulet@ev0ke.net>
> CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> CC: Anton Blanchard <anton@samba.org>
> CC: David S. Miller <davem@davemloft.net>
> CC: stable <stable@kernel.org>

Applied, thanks.
