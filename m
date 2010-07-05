Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0GEMGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:06:25 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:38449 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab0GEMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:06:24 -0400
Date: Mon, 5 Jul 2010 20:06:17 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Fwd: Possible bug in net/ipv4/route.c?
Message-ID: <20100705120617.GA6267@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278049111.2597.6.camel@edumazet-laptop>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>> 2) The layer using skb->cb[] should clear this area after use and
>> before handing the skb to another layer.  Ubicom should modify the
>> driver to clear the skb->cb[] area before sending it up the line.
>> 
> 
> This is the right option. If you use one word in cb[], only your driver
> knows how to clear it efficiently.

Absolutely not! No protocol stack should rely on an external skb
having a zero cb.

Please fix the bridge instead as it's doing the IP injection.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
