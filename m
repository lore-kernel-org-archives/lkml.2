Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2KCQfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:35:13 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:12895
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756721Ab2KCQfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:35:10 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161258256"
Date: Sat, 3 Nov 2012 17:35:07 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: walter harms <wharms@bfs.de>
cc: Julia Lawall <julia.lawall@lip6.fr>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] drivers/net/ethernet/ibm/emac/mal.c: use WARN
In-Reply-To: <509545C0.5050000@bfs.de>
Message-ID: <alpine.DEB.2.02.1211031733330.1955@localhost6.localdomain6>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <1351940317-14812-11-git-send-email-Julia.Lawall@lip6.fr> <50950055.8040307@bfs.de> <alpine.DEB.2.02.1211031513220.1955@localhost6.localdomain6> <509545C0.5050000@bfs.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While looking i have noticed that a lot of drivers define there private "assert" macro.
> It is very similar to warn.
>
> (e.g.)
> #define RTL819x_DEBUG
> #ifdef RTL819x_DEBUG
> #define assert(expr) \
>        if (!(expr)) {                                  \
>                 printk( "Assertion failed! %s,%s,%s,line=%d\n", \
>                #expr,__FILE__,__FUNCTION__,__LINE__);          \
>        }

WARN is more complicated.  At least with the right debugging options 
turned on, it dumps the stack, via warn_slowpath_common.

julia
