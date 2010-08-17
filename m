Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0HQFuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:50:12 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:59136 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab0HQFuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:50:10 -0400
Subject: Re: [PATCH 10/16] drivers/net/wireless/wl12xx: Use available error
 codes
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Julia Lawall <julia@diku.dk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1008161827140.19313@ask.diku.dk>
References: <Pine.LNX.4.64.1008161827140.19313@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 08:42:21 +0300
Message-ID: <1282023741.1773.9.camel@powerslave>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 18:27 +0200, ext Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Error codes are stored in ret, but the return value is always 0.  Return
> ret instead.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> local idexpression x;
> constant C;
> @@
> 
> if (...) { ...
>   x = -C
>   ... when != x
> (
>   return <+...x...+>;
> |
>   return NULL;
> |
>   return;
> |
> * return ...;
> )
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---


This was indeed a bug.  Thanks!

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

-- 
Cheers,
Luca.

