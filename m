Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab1CCVix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:38:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27438 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1CCViw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:38:52 -0500
Message-ID: <4D700A18.8070708@kernel.org>
Date: Thu, 03 Mar 2011 13:37:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: move bootnode definition into srat_64.c
References: <4D6EECE8.80500@kernel.org> <alpine.DEB.2.00.1103031251460.9993@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103031251460.9993@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D700A60.0054,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 12:52 PM, David Rientjes wrote:
> On Wed, 2 Mar 2011, Yinghai Lu wrote:
> 
>> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
>> index 8e9d339..7e5d0e9 100644
>> --- a/arch/x86/mm/srat_64.c
>> +++ b/arch/x86/mm/srat_64.c
>> @@ -26,6 +26,11 @@
>>  
>>  int acpi_numa __initdata;
>>  
>> +struct bootnode {
>> +	u64 start;
>> +	u64 end;
>> +};
>> +
>>  static struct bootnode nodes_add[MAX_NUMNODES];
>>  
>>  static __init int setup_node(int pxm)
> 
> Can we get rid of struct bootnode instead and simply reuse 
> struct numa_memblk?  The latter isn't actually tied to memblock and is a 
> generic representation of a node id and address range.

Yes, could be don later esp if the hotplug mem code would support 
more than one block add per node.

Yinghai
