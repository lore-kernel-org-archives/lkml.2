Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2APHhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:37:10 -0500
Received: from mx2.parallels.com ([64.131.90.16]:40944 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2APHhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:37:08 -0500
Message-ID: <4F13D376.7020500@parallels.com>
Date: Mon, 16 Jan 2012 11:36:22 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
References: <20120109163812.4cb695944ea9716953afbfc9@canb.auug.org.au> <20120108.225225.1735038078666958154.davem@davemloft.net>
In-Reply-To: <20120108.225225.1735038078666958154.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 10:52 AM, David Miller wrote:
> From: Stephen Rothwell<sfr@canb.auug.org.au>
> Date: Mon, 9 Jan 2012 16:38:12 +1100
>
>> I applied the following patch for today:
>>
>> From: Stephen Rothwell<sfr@canb.auug.org.au>
>> Date: Mon, 9 Jan 2012 16:33:16 +1100
>> Subject: [PATCH] net: sk_update_clone is only used in net/core/sock.c
>>
>> so move it there.  Fixes build errors when CONFIG_INET is not defeined:
>>
>> In file included from include/linux/tcp.h:211:0,
>>                   from include/linux/ipv6.h:221,
>>                   from include/net/ipv6.h:16,
>>                   from include/linux/sunrpc/clnt.h:26,
>>                   from include/linux/nfs_fs.h:50,
>>                   from init/do_mounts.c:20:
>> include/net/sock.h: In function 'sk_update_clone':
>> include/net/sock.h:1109:3: error: implicit declaration of function 'sock_update_memcg' [-Werror=implicit-function-declaration]
>>
>> Signed-off-by: Stephen Rothwell<sfr@canb.auug.org.au>
>
> Applied, thanks Stephen.
This is not the proper fix.
Although it can stay for a matter of style if you guys prefer the inline 
function definition to live in sock.c since no one else uses it.
I'll send a patch to fix this, that can live ontop of yours, shortly.
