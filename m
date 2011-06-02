Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1FBEUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 00:20:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46182 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1FBEUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 00:20:47 -0400
Date: Wed, 01 Jun 2011 21:20:36 -0700 (PDT)
Message-Id: <20110601.212036.1247786739427089909.davem@davemloft.net>
To: khilman@ti.com
Cc: julia@diku.dk, kernel-janitors@vger.kernel.org, cyril@ti.com, srk@ti.com,
        weil@mail.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] drivers/net/davinci_emac.c: add missing clk_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306957764.26236.37.camel@vence>
References: <1306948213-20767-7-git-send-email-julia@diku.dk>
	<1306957764.26236.37.camel@vence>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Jun 2011 21:20:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@ti.com>
Date: Wed, 01 Jun 2011 12:49:24 -0700

> On Wed, 2011-06-01 at 19:10 +0200, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>> 
>> Go to existing error handling code at the end of the function that calls
>> clk_put.
>> 
>> A simplified version of the semantic match that finds this problem is as
>> follows: (http://coccinelle.lip6.fr/)
>> 
>> // <smpl>
>> @r exists@
>> expression e1,e2;
>> statement S;
>> @@
>> 
>> e1 = clk_get@p1(...);
>> ... when != e1 = e2
>>     when != clk_put(e1)
>>     when any
>> if (...) { ... when != clk_put(e1)
>>                when != if (...) { ... clk_put(e1) ... }
>> * return@p3 ...;
>>  } else S
>> // </smpl>
>> 
>> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Acked-by: Kevin Hilman <khilman@ti.com>

Applied, thanks.
