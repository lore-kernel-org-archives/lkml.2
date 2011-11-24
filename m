Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1KXHTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:19:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:37467 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1KXHTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:19:18 -0500
Subject: Re: [PATCH 8/9] arch/powerpc/sysdev/ehv_pic.c: add missing kfree
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1312802283-9107-8-git-send-email-julia@diku.dk>
Date: Thu, 24 Nov 2011 01:16:59 -0600
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Timur Tabi <timur@freescale.com>,
        Ashish Kalra <ashish.kalra@freescale.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3C33B018-7DA9-4818-A569-E3030ED993EE@kernel.crashing.org>
References: <1312802283-9107-8-git-send-email-julia@diku.dk>
To: Julia Lawall <julia@diku.dk>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 8, 2011, at 6:18 AM, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> At this point, ehv_pic has been allocated but not stored anywhere, so it
> should be freed before leaving the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @exists@
> local idexpression x;
> statement S,S1;
> expression E;
> identifier fl;
> expression *ptr != NULL;
> @@
> 
> x = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> <... when != x
>     when != if (...) { <+...kfree(x)...+> }
>     when any
>     when != true x == NULL
> x->fl
> ...>
> (
> if (x == NULL) S1
> |
> if (...) { ... when != x
>               when forall
> (
> return \(0\|<+...x...+>\|ptr\);
> |
> * return ...;
> )
> }
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> arch/powerpc/sysdev/ehv_pic.c |    1 +
> 1 file changed, 1 insertion(+)

applied to next

- k
