Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2I1DoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:44:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28214 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab2I1DoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:44:12 -0400
Message-ID: <50651CF5.5030903@oracle.com>
Date: Fri, 28 Sep 2012 11:43:49 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        levinsasha928@gmail.com, Feng Jin <joe.jin@oracle.com>,
        dan.carpenter@oracle.com
Subject: Re: [PATCH -v2] mm: frontswap: fix a wrong if condition in frontswap_shrink
References: <505C27FE.5080205@oracle.com> <1348745730.1512.19.camel@x61.thuisdomein>
In-Reply-To: <1348745730.1512.19.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012-09-27 19:35, Paul Bolle wrote:
> On Fri, 2012-09-21 at 16:40 +0800, Zhenzhong Duan wrote:
>>
>> @@ -275,7 +280,7 @@ static int __frontswap_shrink(unsigned long target_pages,
>>   	if (total_pages<= target_pages) {
>>   		/* Nothing to do */
>>   		*pages_to_unuse = 0;
>
> I think setting pages_to_unuse to zero here is not needed. It is
> initiated to zero in frontswap_shrink() and hasn't been touched since.
> See my patch at https://lkml.org/lkml/2012/9/27/250.
Yes, it's unneeded. But I didn't see warning as you said in above link 
when run 'make V=1 mm/frontswap.o'.
>> -		return 0;
>> +		return 1;
>>   	}
>>   	total_pages_to_unuse = total_pages - target_pages;
>>   	return __frontswap_unuse_pages(total_pages_to_unuse, pages_to_unuse, type);
>> @@ -302,7 +307,7 @@ void frontswap_shrink(unsigned long target_pages)
>>   	spin_lock(&swap_lock);
>>   	ret = __frontswap_shrink(target_pages,&pages_to_unuse,&type);
>>   	spin_unlock(&swap_lock);
>> -	if (ret == 0&&  pages_to_unuse)
>> +	if (ret == 0)
>>   		try_to_unuse(type, true, pages_to_unuse);
>>   	return;
>>   }
>
> Are you sure pages_to_unuse won't be zero here? I've stared quite a bit
> at __frontswap_unuse_pages() and it's not obvious pages_to_unuse (there
> also called unused) will never be zero when that function returns zero.
pages_to_unuse==0 means all pages need to be unused.

zduan

