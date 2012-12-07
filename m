Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2LGKpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:45:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2LGKpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:45:30 -0500
Message-ID: <50C1C8C0.2020006@gmail.com>
Date: Fri, 07 Dec 2012 18:45:20 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: fix unused variable sparse warning
References: <1354838913-20084-1-git-send-email-dinggnu@gmail.com> <20121207001545.GE2510@gmail.com>
In-Reply-To: <20121207001545.GE2510@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Ding said, at 2012/12/7 8:15:
> On Fri, Dec 07, 2012 at 12:06:44AM +0000, Cong Ding wrote:
>> the variables zero and unres_qlen_max are only used when CONFIG_SYSCTL is
>> defined, otherwise it causes the following sparse warning when we turn on
>> CONFIG_SYSCTL.
> sorry for disturbing again, the sparse warning is
> net/core/neighbour.c:65:12: warning: ‘zero’ defined but not used [-Wunused-variable]
> net/core/neighbour.c:66:12: warning: ‘unres_qlen_max’ defined but not used [-Wunused-variable]
> 
> it happens if we turn off CONFIG_SYSCTL.

It has been fixed yesterday.
see b93196dc5af7729ff7cc50d3d322ab1a364aa14f

> 
>>
>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>> ---
>>  net/core/neighbour.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> index 36fc692..4a15278 100644
>> --- a/net/core/neighbour.c
>> +++ b/net/core/neighbour.c
>> @@ -62,8 +62,10 @@ static void __neigh_notify(struct neighbour *n, int type, int flags);
>>  static void neigh_update_notify(struct neighbour *neigh);
>>  static int pneigh_ifdown(struct neigh_table *tbl, struct net_device *dev);
>>  
>> +#ifdef CONFIG_SYSCTL
>>  static int zero;
>>  static int unres_qlen_max = INT_MAX / SKB_TRUESIZE(ETH_FRAME_LEN);
>> +#endif
>>  
>>  static struct neigh_table *neigh_tables;
>>  #ifdef CONFIG_PROC_FS
>> -- 
>> 1.7.4.5
>>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

