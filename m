Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2LYVh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 16:37:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52491 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2LYVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 16:37:57 -0500
Date: Tue, 25 Dec 2012 13:37:53 -0800 (PST)
Message-Id: <20121225.133753.1383155065923849678.davem@davemloft.net>
To: akinobu.mita@gmail.com
Cc: ordex@autistici.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, lindner_marek@yahoo.de,
        siwu@hrz.tu-chemnitz.de, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 19/29] batman-adv: fix random jitter calculation
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAC5umyh1d9XxH2We4e2rjV-OYhbP2ObGC_iwrDeff2hphJ7TzQ@mail.gmail.com>
References: <1356315256-6572-20-git-send-email-akinobu.mita@gmail.com>
	<20121225112657.GC2604@ritirata.org>
	<CAC5umyh1d9XxH2We4e2rjV-OYhbP2ObGC_iwrDeff2hphJ7TzQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 26 Dec 2012 06:35:37 +0900

> 2012/12/25 Antonio Quartulli <ordex@autistici.org>:
>> On Mon, Dec 24, 2012 at 11:14:06AM +0900, Akinobu Mita wrote:
>>> batadv_iv_ogm_emit_send_time() attempts to calculates a random integer
>>> in the range of 'orig_interval +- BATADV_JITTER' by the below lines.
>>>
>>>         msecs = atomic_read(&bat_priv->orig_interval) - BATADV_JITTER;
>>>         msecs += (random32() % 2 * BATADV_JITTER);
>>>
>>> But it actually gets 'orig_interval' or 'orig_interval - BATADV_JITTER'
>>> because '%' and '*' have same precedence and associativity is
>>> left-to-right.
>>>
>>> This adds the parentheses at the appropriate position so that it matches
>>> original intension.
>>>
>>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>>> Cc: Marek Lindner <lindner_marek@yahoo.de>
>>> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
>>> Cc: Antonio Quartulli <ordex@autistici.org>
>>> Cc: b.a.t.m.a.n@lists.open-mesh.org
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: netdev@vger.kernel.org
>>> ---
>>
>> Acked-by: Antonio Quartulli <ordex@autistici.org>
>>
>> But I would suggest to apply this change to net, since it is a fix.
> 
> I agree.
> David, please consider to apply this patch for 3.8-rc*.
> 

All patches I should consider seriously should be properly
reposted for review and inclusion.
