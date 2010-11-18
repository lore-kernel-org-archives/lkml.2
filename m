Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0KRTSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:18:38 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:45197 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0KRTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZiycyN2d3Y04SvsZ0FhR9wBhfiYXGVJLbuG5kwIsWLy245T77n3jd0LUi/1XenwoZK
         IV20B1pXB2NF9xAHJ8qFuqVilqjJY9474Qy8HxPb/MavekrM4O8Lk5e3fVoG0C1y32GQ
         J/24JwjeA0WOVU5wDNXFoePXSyFhwN81naVwY=
Message-ID: <4CE57C06.4080105@gmail.com>
Date: Thu, 18 Nov 2010 11:18:30 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, horms@verge.net.au,
        netfilter-devel@vger.kernel.org
Subject: Re: error while building the kernel Mainline
References: <1290093135.2781.167.camel@edumazet-laptop>	<4CE561A2.2020600@gmail.com>	<1290102497.2781.242.camel@edumazet-laptop> <20101118.095046.28818361.davem@davemloft.net> <4CE56CC4.4020107@gmail.com> <4CE56E89.4000902@trash.net>
In-Reply-To: <4CE56E89.4000902@trash.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 10:20 AM, Patrick McHardy wrote:
> Am 18.11.2010 19:13, schrieb Justin P. Mattock:
>> On 11/18/2010 09:50 AM, David Miller wrote:
>>> From: Eric Dumazet<eric.dumazet@gmail.com>
>>> Date: Thu, 18 Nov 2010 18:48:17 +0100
>>>
>>>> Let me guess...
>>>>
>>>> net/netfilter/nf_conntrack_core is compiled as a module, and ip_vs
>>>> statically (in vmlinux) ?
>>>>
>>>> CONFIG_NF_CONNTRACK=m
>>>> CONFIG_IP_VS=y
>>>>
>>>> We probably need some Kconfig magic ;)
>>>
>
> Please try whether this patch fixes the problem.
>
> netfilter: fix IP_VS dependencies
>
> When NF_CONNTRACK is enabled, IP_VS uses conntrack symbols.
> Therefore IP_VS can't be linked statically when conntrack
> is built modular.
>
> Reported-by: Justin P. Mattock<justinmattock@gmail.com>
> Signed-off-by: Patrick McHardy<kaber@trash.net>
>
>


alright!! doing the above change
CONFIG_NF_CONNTRACK=y gets a clean build.. as well as reverting 
everything and using your patch..

Thanks for the fix..

Justin P. Mattock
