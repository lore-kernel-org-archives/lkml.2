Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab2EINQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:16:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39813 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab2EINQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:16:14 -0400
Message-ID: <4FAA6DE6.3040001@arm.com>
Date: Wed, 09 May 2012 14:15:18 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH] mach-shmobile: Emma Mobile EV2 SMP prototype code
References: <20120509075407.5991.60556.sendpatchset@w520> <201205091212.08239.arnd@arndb.de>
In-Reply-To: <201205091212.08239.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
X-OriginalArrivalTime: 09 May 2012 13:16:58.0532 (UTC) FILETIME=[03562E40:01CD2DE6]
X-MC-Unique: 112050914154009601
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/12 13:12, Arnd Bergmann wrote:
> On Wednesday 09 May 2012, Magnus Damm wrote:
>>  static unsigned int __init shmobile_smp_get_core_count(void)
>>  {
>> @@ -31,6 +32,9 @@ static unsigned int __init shmobile_smp_
>>  	if (is_r8a7779())
>>  		return r8a7779_get_core_count();
>>  
>> +	if (is_emev2())
>> +		return emev2_get_core_count();
>> +
>>  	return 1;
>>  }
>>  
>> @@ -41,6 +45,9 @@ static void __init shmobile_smp_prepare_
>>  
>>  	if (is_r8a7779())
>>  		r8a7779_smp_prepare_cpus();
>> +
>> +	if (is_emev2())
>> +		emev2_smp_prepare_cpus();
>>  }
>>  
>>  int shmobile_platform_cpu_kill(unsigned int cpu)
>> ...
> 
> This shows that we really want an abstraction for soc-specific SMP ops
> even within one platform, and we'll need the same thing for multiplatform.
> 
> Marc Zyngier already proposed a solution for this last year, but I
> think we couldn't agree on the details back then before he lost interest.
> I think we should pick that up again and get it into 3.6 so the code above
> can be simplified and we can do the multiplatform solution. We'll probably
> discuss the details in Hong Kong in a couple of weeks, so there is no
> point in changing it now, but I'd hope that you can migrate this to
> whatever we come up with in the following merge window.

I'm happy to revive the series if there is an interest.

	M.
-- 
Jazz is not dead. It just smells funny...

