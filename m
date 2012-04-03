Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2DCWFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:05:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38770 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2DCWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:05:09 -0400
Date: Tue, 03 Apr 2012 18:03:02 -0400 (EDT)
Message-Id: <20120403.180302.342779808900865443.davem@davemloft.net>
To: kaffeemonster@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, matt@ozlabs.org, eric.dumazet@gmail.com
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F75D2A5.7060407@googlemail.com>
References: <4F75CA89.4010709@googlemail.com>
	<4F75D2A5.7060407@googlemail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 15:03:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Seiffert <kaffeemonster@googlemail.com>
Date: Fri, 30 Mar 2012 17:35:01 +0200

> Now the helper function from filter.c for negative offsets is exported,
> it can be used it in the jit to handle negative offsets.
> 
> First modify the asm load helper functions to handle:
> - know positive offsets
> - know negative offsets
> - any offset
> 
> then the compiler can be modified to explicitly use these helper
> when appropriate.
> 
> This fixes the case of a negative X register and allows to lift
> the restriction that bpf programs with negative offsets can't
> be jited.
> 
> Signed-off-by: Jan Seiffert <kaffeemonster@googlemail.com>
> 
> I have only compile tested this, -ENOHARDWARE.
> Can someone with more powerpc kung-fu review and maybe test this?
> Esp. powerpc asm is not my strong point. I think i botched the
> stack frame in the call setup. Help?

I'm not applying this until a powerpc person tests it.

Also, we have an ARM JIT in the tree which probably needs to
be fixed similarly.
