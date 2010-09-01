Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab0IAR7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:59:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58785
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755940Ab0IAR7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:59:40 -0400
Date: Wed, 01 Sep 2010 10:59:55 -0700 (PDT)
Message-Id: <20100901.105955.176668287.davem@davemloft.net>
To: wg@grandegger.com
Cc: w.sang@pengutronix.de, julia@diku.dk, kernel-janitors@vger.kernel.org,
        grant.likely@secretlab.ca, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 3/4] drivers/net/can/mscan/mpc5xxx_can.c: Add
 of_node_put to avoid memory leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C7D565F.307@grandegger.com>
References: <Pine.LNX.4.64.1008311943280.2668@ask.diku.dk>
	<20100831191014.GA9603@pengutronix.de>
	<4C7D565F.307@grandegger.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Tue, 31 Aug 2010 21:22:07 +0200

> On 08/31/2010 09:10 PM, Wolfram Sang wrote:
>> On Tue, Aug 31, 2010 at 07:44:00PM +0200, Julia Lawall wrote:
>>> Add a call to of_node_put in the error handling code following a call to
>>> of_find_matching_node.
>>>
>>> This patch also moves the existing call to of_node_put after the call to
>>> iounmap in the error handling code, to make it possible to jump to
>>> of_node_put without doing iounmap.  These appear to be disjoint operations,
>>> so the ordering doesn't matter.
>>>
>>> This patch furthermore changes the -ENODEV result in the error handling
>>> code for of_find_matching_node to a return of 0, as found in the error
>>> handling code for of_iomap, because the return type of the function is
>>> unsigned.
>>>
>>> The semantic match that finds this problem is as follows:
>>> (http://coccinelle.lip6.fr/)
 ...
>>> Signed-off-by: Julia Lawall <julia@diku.dk>
>> 
>> Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
> 
> Acked-by: Wolfgang Grandegger <wg@grandegger.com>

Applied.
