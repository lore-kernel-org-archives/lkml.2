Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2DCWCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:02:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38743 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2DCWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:02:40 -0400
Date: Tue, 03 Apr 2012 18:02:36 -0400 (EDT)
Message-Id: <20120403.180236.324578658342931623.davem@davemloft.net>
To: kaffeemonster@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [REGRESSION][PATCH V4 2/3] bpf jit: Let the x86 jit handle
 negative offsets
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F75D015.30609@googlemail.com>
References: <4F75CA89.4010709@googlemail.com>
	<4F75D015.30609@googlemail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 15:02:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Seiffert <kaffeemonster@googlemail.com>
Date: Fri, 30 Mar 2012 17:24:05 +0200

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
> Signed-of-by: Jan Seiffert <kaffeemonster@googlemail.com>

Applied, but with trailing empty lines removed:

> diff --git a/arch/x86/net/bpf_jit.S b/arch/x86/net/bpf_jit.S
> index 6687022..2897d7f 100644
> --- a/arch/x86/net/bpf_jit.S
> +++ b/arch/x86/net/bpf_jit.S
> +	ret
> +

There.
