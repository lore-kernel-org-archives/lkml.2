Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab0HaVnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:43:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:42473 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab0HaVni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:43:38 -0400
Subject: Re: [PATCH 5/7] arch/powerpc/sysdev/qe_lib/qe.c: Add of_node_put to avoid memory leak
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1283075566-27441-6-git-send-email-julia@diku.dk>
Date: Tue, 31 Aug 2010 16:41:24 -0500
Cc: Timur Tabi <timur@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: 7bit
Message-Id: <7C2AF4A1-A33B-4D1F-859A-BCB48738D9D1@kernel.crashing.org>
References: <1283075566-27441-1-git-send-email-julia@diku.dk> <1283075566-27441-6-git-send-email-julia@diku.dk>
To: Julia Lawall <julia@diku.dk>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 29, 2010, at 4:52 AM, Julia Lawall wrote:

> Add a call to of_node_put in the error handling code following a call to
> of_find_compatible_node.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> expression E,E1;
> statement S;
> @@
> 
> *x = 
> (of_find_node_by_path
> |of_find_node_by_name
> |of_find_node_by_phandle
> |of_get_parent
> |of_get_next_parent
> |of_get_next_child
> |of_find_compatible_node
> |of_match_node
> )(...);
> ...
> if (x == NULL) S
> <... when != x = E
> *if (...) {
>  ... when != of_node_put(x)
>      when != if (...) { ... of_node_put(x); ... }
> (
>  return <+...x...+>;
> |
> *  return ...;
> )
> }
> ...>
> of_node_put(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> arch/powerpc/sysdev/qe_lib/qe.c |    1 +
> 1 file changed, 1 insertion(+)

applied to merge

- k
