Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1IAWBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:01:00 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49952 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1IAWA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:00:59 -0400
Message-ID: <4E600090.5030505@gmail.com>
Date: Fri, 02 Sep 2011 06:00:48 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dev_ioctl should return -EINVAL for unknown ioctl instead
 of -ENOTTY
References: <4E5F9C14.1040108@gmail.com> <1314891670.2733.12.camel@bwh-desktop>
In-Reply-To: <1314891670.2733.12.camel@bwh-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年09月01日 23:41, Ben Hutchings wrote:
> On Thu, 2011-09-01 at 22:52 +0800, Wang Sheng-Hui wrote:
>> The patch is against 3.1-rc3.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  net/core/dev.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 17d67b5..de6033c 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -5092,7 +5092,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
>>  		/* Take care of Wireless Extensions */
>>  		if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST)
>>  			return wext_handle_ioctl(net, &ifr, cmd, arg);
>> -		return -ENOTTY;
>> +		return -EINVAL;
>>  	}
>>  }
>>  
> 
> Whereas, Linus Torvalds wrote in
> <BANLkTin=PTbTwBR2s+owMLy+GmKigeoYvg@mail.gmail.com>:
> [...]
>> The correct error code for "I don't understand this ioctl" is ENOTTY.
>> The naming may be odd, but you should think of that error value as a
>> "unrecognized ioctl number, you're feeding me random numbers that I
>> don't understand and I assume for historical reasons that you tried to
>> do some tty operation on me".
> [...]
> 
> (Not that we are consistent about using ENOTTY in networking now.)
> 
> Ben.
> 

Got it. Thanks.
