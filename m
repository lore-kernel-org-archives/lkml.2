Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab0LCCIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 21:08:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758312Ab0LCCIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 21:08:41 -0500
Message-ID: <4CF85238.7010508@redhat.com>
Date: Fri, 03 Dec 2010 10:13:12 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        Neil Horman <nhorman@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>
Subject: Re: [v2 PATCH 1/2] bonding: sync netpoll code with bridge
References: <20101202134041.6073.5201.sendpatchset@localhost.localdomain> <20101202103650.06647704@nehalam>
In-Reply-To: <20101202103650.06647704@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/10 02:36, Stephen Hemminger wrote:
> On Thu, 2 Dec 2010 08:35:42 -0500
> Amerigo Wang<amwang@redhat.com>  wrote:
>
>>   #ifdef CONFIG_NET_POLL_CONTROLLER
>> -	if (unlikely(bond->dev->priv_flags&  IFF_IN_NETPOLL)) {
>> -		struct netpoll *np = bond->dev->npinfo->netpoll;
>> -		slave_dev->npinfo = bond->dev->npinfo;
>> +	if (unlikely(netpoll_tx_running(slave_dev))) {
>>   		slave_dev->priv_flags |= IFF_IN_NETPOLL;
>> -		netpoll_send_skb_on_dev(np, skb, slave_dev);
>> +		bond_netpoll_send_skb(bond_get_slave_by_dev(bond, slave_dev), skb);
>>   		slave_dev->priv_flags&= ~IFF_IN_NETPOLL;
>>   	} else
>>   #endif
>
> Couldn't you eliminate #ifdef by putting the following into header file.
>
> #ifdef CONFIG_NET_POLL_CONTROLLER
> static inline netpoll_tx_running
> ...
> #else
> #define netpoll_tx_running(dev)  (0)
> #endif
>

Oh, nice idea! Will change this in the next update.

Thanks.
