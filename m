Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab2EXCms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 22:42:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59875 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2EXCmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 22:42:46 -0400
Subject: Re: [PATCH V2] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "kun.jiang" <kunx.jiang@intel.com>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        YMZHANG <yanmin_zhang@linux.intel.com>, davem@davemloft.net
In-Reply-To: <4FBD9161.3040206@intel.com>
References: <4FBD9161.3040206@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 04:42:42 +0200
Message-ID: <1337827362.3361.3800.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 09:39 +0800, kun.jiang wrote:
> From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> 
> We hit a kernel OOPS.
> 
...
> 
> Function free_fib_info resets nexthop_nh->nh_dev to NULL before releasing
> fi. Other cpu might be accessing fi. Fixing it by delaying the releasing.
> 
> With the patch, we ran MTBF testing on Android mobile for 12 hours
> and didn't trigger the issue.
> 
> Thank Eric for very detailed review/checking the issue.
> 
> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: Kun Jiang <kunx.jiang@intel.com>
> ---
>  net/ipv4/fib_semantics.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !


