Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1CGX55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:57:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35122
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab1CGX5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:57:55 -0500
Date: Mon, 07 Mar 2011 15:58:32 -0800 (PST)
Message-Id: <20110307.155832.52202423.davem@davemloft.net>
To: arnd@arndb.de
Cc: nikai@nikai.net, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/macvtap: fix error check
From: David Miller <davem@davemloft.net>
In-Reply-To: <201103071059.04321.arnd@arndb.de>
References: <20110305004941.7b195e9d@absol.kitzblitz>
	<201103071059.04321.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 7 Mar 2011 10:59:04 +0100

> On Saturday 05 March 2011, Nicolas Kaiser wrote:
>> 'len' is unsigned of type size_t and can't be negative.
>> 
>> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> I think it's harmless: the worst thing that can happen is
> macvtap_alloc_skb() failing with ENOMEM when it gets a
> large argument, but we could have it in -stable just to
> be sure.

I'm just going to add it to net-2.6

I verified that gcc is not generating this test at all
currently, so putting this into -stable is quite pointless.
