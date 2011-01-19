Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1ASAN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:13:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34795
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711Ab1ASAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:13:58 -0500
Date: Tue, 18 Jan 2011 16:14:31 -0800 (PST)
Message-Id: <20110118.161431.245411919.davem@davemloft.net>
To: bcrl@kvack.org
Cc: jj@chaosbits.net, netdev@vger.kernel.org, linux-ns83820@kvack.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, segooon@gmail.com,
        dkirjanov@kernel.org
Subject: Re: [PATCH] ns83820: Avoid bad pointer deref in ns83820_init_one().
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110118164200.GI17839@kvack.org>
References: <alpine.LNX.2.00.1101172116330.27021@swampdragon.chaosbits.net>
	<20110118164200.GI17839@kvack.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin LaHaise <bcrl@kvack.org>
Date: Tue, 18 Jan 2011 11:42:00 -0500

> On Mon, Jan 17, 2011 at 09:24:57PM +0100, Jesper Juhl wrote:
>> In drivers/net/ns83820.c::ns83820_init_one() we dynamically allocate 
>> memory via alloc_etherdev(). We then call PRIV() on the returned storage 
>> which is 'return netdev_priv()'. netdev_priv() takes the pointer it is 
>> passed and adds 'ALIGN(sizeof(struct net_device), NETDEV_ALIGN)' to it and 
>> returns it. Then we test the resulting pointer for NULL, which it is 
>> unlikely to be at this point, and later dereference it. This will go bad 
>> if alloc_etherdev() actually returned NULL.
>> 
>> This patch reworks the code slightly so that we test for a NULL pointer 
>> (and return -ENOMEM) directly after calling alloc_etherdev().
> 
> Looks good.
> 
> 		-ben
> 
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

Applied, thanks everyone.
