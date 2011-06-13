Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1FMWGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:06:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60960 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1FMWGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:06:50 -0400
Date: Mon, 13 Jun 2011 18:06:21 -0400 (EDT)
Message-Id: <20110613.180621.67079943408650521.davem@davemloft.net>
To: dbaryshkov@gmail.com
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net, slapin@ossfans.org,
        maxim.osipov@siemens.com
Subject: Re: [PATCH] ieee802154: Don't leak memory in ieee802154_nl_fill_phy
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTikBnQADmUpP7J5gmJLXA9-O+4kSvw@mail.gmail.com>
References: <alpine.LNX.2.00.1106121621360.25151@swampdragon.chaosbits.net>
	<BANLkTikBnQADmUpP7J5gmJLXA9-O+4kSvw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 13 Jun 2011 15:06:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Tue, 14 Jun 2011 00:02:38 +0400

> On 6/12/11, Jesper Juhl <jj@chaosbits.net> wrote:
>> In net/ieee802154/nl-phy.c::ieee802154_nl_fill_phy() I see two small
>> issues.
>> 1) If the allocation of 'buf' fails we may just as well return -EMSGSIZE
>>    directly rather than jumping to 'out:' and do a pointless kfree(0).
>> 2) We do not free 'buf' unless we jump to one of the error labels and this
>>    leaks memory.
>> This patch should address both.
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> 
> David, please commit this.

Applied, thanks.
