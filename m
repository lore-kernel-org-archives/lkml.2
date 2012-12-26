Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab2LZWOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 17:14:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35433 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2LZWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 17:14:14 -0500
Date: Wed, 26 Dec 2012 14:13:50 -0800 (PST)
Message-Id: <20121226.141350.999199516661256197.davem@davemloft.net>
To: akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lindner_marek@yahoo.de, siwu@hrz.tu-chemnitz.de, ordex@autistici.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH] batman-adv: fix random jitter calculation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1356525130-2688-1-git-send-email-akinobu.mita@gmail.com>
References: <1356525130-2688-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 26 Dec 2012 21:32:10 +0900

> batadv_iv_ogm_emit_send_time() attempts to calculates a random integer
> in the range of 'orig_interval +- BATADV_JITTER' by the below lines.
> 
>         msecs = atomic_read(&bat_priv->orig_interval) - BATADV_JITTER;
>         msecs += (random32() % 2 * BATADV_JITTER);
> 
> But it actually gets 'orig_interval' or 'orig_interval - BATADV_JITTER'
> because '%' and '*' have same precedence and associativity is
> left-to-right.
> 
> This adds the parentheses at the appropriate position so that it matches
> original intension.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Acked-by: Antonio Quartulli <ordex@autistici.org>

Applied, thanks.
