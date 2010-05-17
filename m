Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0EQSB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:01:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32244 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab0EQSBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:01:24 -0400
Message-ID: <4BF18468.5010005@oracle.com>
Date: Mon, 17 May 2010 11:01:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH -next] bridge: fix build for CONFIG_SYSFS disabled
References: <20100517163521.649526d0.sfr@canb.auug.org.au> <20100517091756.e232bdc2.randy.dunlap@oracle.com> <20100517105654.2451e61f@nehalam>
In-Reply-To: <20100517105654.2451e61f@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4BF1846F.013F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/10 10:56, Stephen Hemminger wrote:
> On Mon, 17 May 2010 09:17:56 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix build when CONFIG_SYSFS is not enabled:
>>
>> net/bridge/br_if.c:136: error: 'struct net_bridge_port' has no member named 'sysfs_name'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  net/bridge/br_if.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> --- linux-next-20100517.orig/net/bridge/br_if.c
>> +++ linux-next-20100517/net/bridge/br_if.c
>> @@ -133,7 +133,9 @@ static void del_nbp(struct net_bridge_po
>>  	struct net_bridge *br = p->br;
>>  	struct net_device *dev = p->dev;
>>  
>> +#ifdef CONFIG_SYSFS
>>  	sysfs_remove_link(br->ifobj, p->sysfs_name);
>> +#endif
>>  
>>  	dev_set_promiscuity(dev, -1);
>>  
> 
> I don't like peppering code with #ifdef like this.

Thanks.  I didn't like it either.

> Turns out that in this place sysfs_name is always the same
> as the device name so instead:
> 
> 
> --- a/net/bridge/br_if.c	2010-05-17 10:40:49.808031840 -0700
> +++ b/net/bridge/br_if.c	2010-05-17 10:49:47.767669246 -0700
> @@ -133,7 +133,7 @@ static void del_nbp(struct net_bridge_po
>  	struct net_bridge *br = p->br;
>  	struct net_device *dev = p->dev;
>  
> -	sysfs_remove_link(br->ifobj, p->sysfs_name);
> +	sysfs_remove_link(br->ifobj, p->dev->name);
>  
>  	dev_set_promiscuity(dev, -1);
>  
> 
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
