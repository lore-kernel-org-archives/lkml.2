Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848Ab2JDAlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:41:50 -0400
Received: from relmlor3.renesas.com ([210.160.252.173]:38354 "EHLO
	relmlor3.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167Ab2JDAls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:41:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,531,1344178800";   d="scan'208";a="100798264"
Message-id: <506CDDB5.5080508@renesas.com>
Date: Thu, 04 Oct 2012 09:52:05 +0900
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: davem@davemloft.net, kernel-janitors@vger.kernel.org,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/20] drivers/net/ethernet/renesas/sh_eth.c: fix error
 return code
References: <1349281090-10013-15-git-send-email-peter.senna@gmail.com>
In-reply-to: <1349281090-10013-15-git-send-email-peter.senna@gmail.com>
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Senna Tschudin さんは書きました:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Acked-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
