Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0CZDe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:34:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60262
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab0CZDe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:34:57 -0400
Date: Thu, 25 Mar 2010 20:35:20 -0700 (PDT)
Message-Id: <20100325.203520.234306178.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [PATCH RFC] fix problems with NETIF_F_HIGHDMA in networking
 drivers v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100326123250A.fujita.tomonori@lab.ntt.co.jp>
References: <20100304135738C.fujita.tomonori@lab.ntt.co.jp>
	<51f3faa71003251803q7ccec5d5x82bc277c590e2848@mail.gmail.com>
	<20100326123250A.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 26 Mar 2010 12:33:12 +0900

> On Thu, 25 Mar 2010 19:03:37 -0600
> Robert Hancock <hancockrwd@gmail.com> wrote:
> 
>> This seems like it could be a reasonable approach. The only thing is
>> that in this code you're returning 1 if the parent device has no DMA
>> mask set. Wouldn't it make more sense to return 0 in this case? I'm
>> assuming that in that situation it's a virtual device not backed by
>> any hardware and there should be no DMA mask restriction...
> 
> I chose the safer option because I don't know enough how net_device
> structure is used. If returning zero in such case is always safe, it's
> fine by me. any example of such virtual device driver?

Like Fujita I'd rather play it safe here.

Even for virtual devices, DMA information up to the root bus
ought to be sane.
