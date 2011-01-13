Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1AMRc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:32:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35520 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab1AMRcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:32:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EiThLlWplFLt1/7RJn77pH//7BR9VCzzCmIzz3TThoXoHOdJ9QYxv/K0s/4zx1JqGX
         nbVswgolPE50Sw75REKs1qh4PP4kjLiwTK6amqLneKY4k12PGRXaNPC4tFqyWZQi6w2p
         gcaF6bdeRBn5k08Qk+br7n25doKP1xoImPi6s=
Message-ID: <4D2F3723.9040405@gmail.com>
Date: Thu, 13 Jan 2011 12:32:19 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 2/2] TCPCT API sockopt update to draft -03
References: <4D2DE824.10205@gmail.com>	<4D2DEC0A.70608@gmail.com> <20110112105608.793787b2@s6510>
In-Reply-To: <20110112105608.793787b2@s6510>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/12/11 1:56 PM, Stephen Hemminger wrote:
> On Wed, 12 Jan 2011 12:59:38 -0500
> William Allen Simpson<william.allen.simpson@gmail.com>  wrote:
>
>> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
>> index e64f4c6..c8f4017 100644
>> --- a/include/linux/tcp.h
>> +++ b/include/linux/tcp.h
>> @@ -185,22 +185,37 @@ struct tcp_md5sig {
>>   #define TCP_COOKIE_PAIR_SIZE	(2*TCP_COOKIE_MAX)
>>
>>   /* Flags for both getsockopt and setsockopt */
>> -#define TCP_COOKIE_IN_ALWAYS	(1<<  0)	/* Discard SYN without cookie */
>> -#define TCP_COOKIE_OUT_NEVER	(1<<  1)	/* Prohibit outgoing cookies,
>> +#define TCPCT_IN_ALWAYS		(1<<  0)	/* Discard SYN without cookie */
>> +#define TCPCT_OUT_NEVER		(1<<  1)	/* Prohibit outgoing cookies,
>
> You end up changing values in kernel userspace API in a way
> that is incompatible with older applications. This is not acceptable.
>
While I agree in principle and argued strongly against it, other
members of the research group (particularly the original project
sponsor) have over-ridden my concerns.  I'm sorry to inform you that
many/most participants don't care much about Linux.

Note that the *bits* are the same, and previously compiled programs
(that don't access more advanced features) should continue to run as
they have in the past.

Even though I'm not paid to work on Linux, I'm doing my best to give you
folks a quick heads up and provide code to rectify the very recent changes
that can be propagated back through the stable tree (to 2.6.33).

As always, what you actually do with my code is up to you....
