Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab1LPPyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:54:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43903 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759758Ab1LPPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:54:17 -0500
Date: Fri, 16 Dec 2011 07:54:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] module: struct module_ref should contains long fields
Message-ID: <20111216155408.GA31770@google.com>
References: <1324012057.2562.23.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324012057.2562.23.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On Fri, Dec 16, 2011 at 06:07:37AM +0100, Eric Dumazet wrote:
> +struct module_ref {
> +	unsigned long incs;
> +	unsigned long decs;
> +} __attribute((aligned(2 * sizeof(unsigned long))));

Why not ____cacheline_aligned?  Another thing is that for percpu
memory, packing could be better or at least shouldn't be worse.
Percpu area usages are likely to be local so one major benefit of
cacheline alignment - avoiding cacheline pingpong - goes away.  The
constant is called SMP_CACHE_BYTES after all.

Thanks.

-- 
tejun
