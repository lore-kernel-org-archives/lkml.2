Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2HMRbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:31:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34909 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab2HMRbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:31:45 -0400
Date: Mon, 13 Aug 2012 19:31:41 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        faisal.latif@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, fubar@us.ibm.com, andy@greyhouse.net,
        divy@chelsio.com, jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, therbert@google.com, xiyou.wangcong@gmail.com,
        joe@perches.com, gregory.v.rose@intel.com, john.r.fastabend@intel.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, bridge@lists.linux-foundation.org,
        fbl@redhat.com
Subject: Re: [patch net-next 15/16] net: remove usage of dev->master
Message-ID: <20120813173141.GB1808@minipsycho.orion>
References: <1344871635-1052-1-git-send-email-jiri@resnulli.us>
 <1344871635-1052-16-git-send-email-jiri@resnulli.us>
 <1344878131.2733.28.camel@bwh-desktop.uk.solarflarecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344878131.2733.28.camel@bwh-desktop.uk.solarflarecom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Aug 13, 2012 at 07:15:31PM CEST, bhutchings@solarflare.com wrote:
>On Mon, 2012-08-13 at 17:27 +0200, Jiri Pirko wrote:
>> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
>> ---
>>  net/core/dev.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index c0f9adb..8977404 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -5461,8 +5461,8 @@ static void rollback_registered_many(struct list_head *head)
>>  		if (dev->netdev_ops->ndo_uninit)
>>  			dev->netdev_ops->ndo_uninit(dev);
>>  
>> -		/* Notifier chain MUST detach us from master device. */
>> -		WARN_ON(dev->master);
>> +		/* Notifier chain MUST detach us all upper devices. */
>> +		WARN_ON(netdev_has_any_upper_dev(dev));
>>  
>>  		/* Remove entries from kobject tree */
>>  		netdev_unregister_kobject(dev);
>
>I think this should be folded into patch 1, since that already ensures
>that any master device is included in the upper device list.

Right, I will squash it into patch 1

>
>Ben.
>
>-- 
>Ben Hutchings, Staff Engineer, Solarflare
>Not speaking for my employer; that's the marketing department's job.
>They asked us to note that Solarflare product names are trademarked.
>
