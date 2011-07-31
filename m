Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1GaDQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 23:16:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46445 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1GaDQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 23:16:16 -0400
Date: Sat, 30 Jul 2011 20:16:09 -0700 (PDT)
Message-Id: <20110730.201609.2157787571393748046.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: shemminger@vyatta.com, paulmck@linux.vnet.ibm.com, mchan@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: RCU: how to suppress warnings from rcu_assign_pointer?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1312028225.2873.104.camel@edumazet-laptop>
References: <20110729003843.GA2373@linux.vnet.ibm.com>
	<20110729105058.2cb9fa86@nehalam.ftrdhcpuser.net>
	<1312028225.2873.104.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 30 Jul 2011 20:16:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 30 Jul 2011 14:17:05 +0200

> Le vendredi 29 juillet 2011 à 10:50 -0700, Stephen Hemminger a écrit :
>> Gcc now generates warnings from rcu_assign_pointer when passed the
>> address of something for example:
>> 	rcu_assign_pointer(dev_queue->qdisc, &noop_qdisc);
>> This warning is harmless and should be surpressed but there maybe
>> other cases where we want that Gcc warning.
>> 
>> I tried various combinations of in rcu_assign_pointer macro
>>   #pragma GCC diagnostic push
>>   #pragma GCC diagnostic ignored "-Wlogical-op"
>>   ...
>>   #pragma GCC diagnostic pop
>> but macro's and pragma's don't nest with the correct scope for
>> this.
>> 
>> Maybe some one with more Gcc foo and time to waste could take
>> a crack at it.
> 
> I would just remove the test from rcu_assign_pointer().
> 
> We now have RCU_INIT_POINTER() for places we dont want/afford the
> smp_wmb()

Agreed:

Acked-by: David S. Miller <davem@davemloft.net>
