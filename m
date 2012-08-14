Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab2HNVAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:00:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37834 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab2HNVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:00:22 -0400
Date: Tue, 14 Aug 2012 14:00:19 -0700 (PDT)
Message-Id: <20120814.140019.1016184364798213214.davem@davemloft.net>
To: shchepetkov@ispras.ru
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH 0/5] Call netif_carrier_off() after register_netdev()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
References: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilya Shchepetkov <shchepetkov@ispras.ru>
Date: Tue, 14 Aug 2012 14:28:50 +0400

> Hi,
> 
> There are several patches on the subject:
> 	
> 	31bde1ceaa873bcaecd49e829bfabceacc4c512d
> 	c55ad8e56b983f03589b38b4504b5d1f41161ff8
> 	e826eafa65c6f1f7c8db5a237556cebac57ebcc5
> 	0d672e9f8ac320c6d1ea9103db6df7f99ea20361
> 	6a3c869a6021f4abcd69aa5fbb15c63f69eb36fe
> 
> In 2008, David Miller wrote in his commit:
> (b47300168e770b60ab96c8924854c3b0eb4260eb)
> 
>>net: Do not fire linkwatch events until the device is registered.
> 
>>Several device drivers try to do things like netif_carrier_off()
>>before register_netdev() is invoked.  This is bogus, but too many
>>drivers do this to fix them all up in one go.
> 
> But I don't understand what will happen in this case?

Sigh... I would strongly suggest that when you don't understand
something you leave it alone until you do.

You can't do the netif_carrier_off() after the device register because
at the precise moment the device is registered it can be openned in
parallel on another cpu and thus cause the entire carrier state
to be changed.

Therefore if you do the netif_carrier_off() afterwards, it might
be overwriting state changes made in another context.

Please just leave this code alone.
