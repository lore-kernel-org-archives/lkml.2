Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2BGSOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:14:52 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35295 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2BGSOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:14:51 -0500
Date: Tue, 07 Feb 2012 13:14:13 -0500 (EST)
Message-Id: <20120207.131413.1550725807432901999.davem@davemloft.net>
To: eilong@broadcom.com
Cc: jj@chaosbits.net, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eliezert@broadcom.com
Subject: Re: [PATCH] bnx2x: Fix mem leak in bnx2x_tpa_stop() if build_skb()
 fails.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328597701.18349.0.camel@lb-tlvb-eilong.il.broadcom.com>
References: <alpine.LNX.2.00.1202062224210.20532@swampdragon.chaosbits.net>
	<1328568833.2476.1.camel@edumazet-laptop>
	<1328597701.18349.0.camel@lb-tlvb-eilong.il.broadcom.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 07 Feb 2012 10:14:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eilon Greenstein" <eilong@broadcom.com>
Date: Tue, 7 Feb 2012 08:55:01 +0200

> On Mon, 2012-02-06 at 23:53 +0100, Eric Dumazet wrote:
>> Le lundi 06 février 2012 à 22:28 +0100, Jesper Juhl a écrit :
>> > We allocate memory for 'new_data' with kmalloc(). If we get the memory
>> > we then try to build_skb() and if that should fail (which it can) we
>> > do not enter 'if (likely(skb)) {' and actually use 'new_data' but
>> > instead fall through to the 'drop:' label and end up returning from
>> > the function without ever assigning 'new'data' to anything or freeing
>> > it. That leaks the memory allocated to 'new_data'.
>> > 
>> > This patch fixes the memory leak by doing a kfree(new_data) in the
>> > case where build_skb() fails (or where allocation of 'new_data' itself
>> > fails, but in taht case it's just a harmless kfree(NULL)).
>> > 
>> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
...
>> Good catch, my bad.
>> 
>> Thanks
>> 
>> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Indeed - nice catch. Thanks Jesper.
> 
> Acked-by: Eilon Greenstein <eilong@broadcom.com>

Applied, thanks everyone.
