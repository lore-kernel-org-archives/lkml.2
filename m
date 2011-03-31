Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab1CaWVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 18:21:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27884 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1CaWVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 18:21:20 -0400
Message-ID: <4D94FE37.8070109@kernel.org>
Date: Thu, 31 Mar 2011 15:20:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl>
In-Reply-To: <201103312348.53678.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D94FE46.000E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 02:48 PM, Rafael J. Wysocki wrote:
> On Thursday, March 31, 2011, Stefano Stabellini wrote:
>> On Thu, 31 Mar 2011, Michael Leun wrote:
>>> Nope, unfortunately this does not change anything (neither when
>>> applying ontop of the tree resulting from bisecting, nor ontop
>>> 2.6.38.2).
>>>
>>> Just to make shure there was no mistake when bisecting I did
>>>
>>> patch -R -p1<~/linux-2.6.38.y.git-ff518ea26654e05d325d996f6e3a7f5f569cc2d5.txt
>>>
>>> and then indeed it worked again.
>>
>> This patch fixes it for me.
>>
>>
>> ---
>>
>> save cr4 to mmu_cr4_features at boot time
>>
>> Signed-off-by: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
>
> Acked-by: Rafael J. Wysocki<rjw@sisk.pl>
>
> Peter, Ingo, please regard this as urgent, it breaks -stable.
>
> Thanks,
> Rafael
>
>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 5a0484a..0943eb2 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -891,6 +891,7 @@ void __init setup_arch(char **cmdline_p)
>>   		max_low_pfn = max_pfn;
>>
>>   	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
>> +	mmu_cr4_features = read_cr4();
>>   #endif
>>
>>   	/*

Stefano, can you explain why it fixes the problem?

or original patch uncover the bug?

Thanks

Yinghai
