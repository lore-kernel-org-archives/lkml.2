Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0CSPsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:48:38 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:32891 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323Ab0CSPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:48:37 -0400
Message-ID: <4BA39CD1.8060900@rsk.demon.co.uk>
Date: Fri, 19 Mar 2010 15:48:33 +0000
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tj@kernel.org, fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] percpu misaligned allocation
References: <20100319013119.GB22095@nowhere>	<20100318.185757.39197211.davem@davemloft.net>	<4BA2DF0B.9080600@kernel.org> <20100318.200205.59696640.davem@davemloft.net>
In-Reply-To: <20100318.200205.59696640.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/10 03:02, David Miller wrote:
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 19 Mar 2010 11:18:51 +0900
> 
>> On 03/19/2010 10:57 AM, David Miller wrote:
>>> I would use u64 so something like:
>>>
>>> 	u64 [FTRACE_MAX_PROFILE_SIZE / sizeof(u64)]
>>
>> <paranoid>DIV_ROUND_UP() would be safer than division</paranoid>
> 
> There's potential real trouble if it isn't a multiple of sizeof(u64)
> so better:
> 
> 	BUILD_BUG_ON(FTRACE_MAX_PROFILE_SIZE % sizeof(u64));
> 
> :-)
> 
> What a mess, just because this thing can't be typed properly :-/
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Couldn't you use a union?

For example if you have
union test {
	long t;
	char buffer[50];
};
gcc will then do the right thing.

on x86_64 sizeof(union test) = 56
but on x86_32 it's only 52.

regards
Richard

