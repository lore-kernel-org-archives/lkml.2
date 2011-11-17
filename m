Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1KQInn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:43:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49381 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1KQInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:43:41 -0500
Message-ID: <4EC4C939.9080401@evidence.eu.com>
Date: Thu, 17 Nov 2011 09:43:37 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] /fs/proc/meminfo.c: fix compilation error
References: <4EB2C0DF.9050301@evidence.eu.com> <alpine.DEB.2.00.1111162105400.13603@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111162105400.13603@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/11/2011 06:06, David Rientjes ha scritto:
> On Thu, 3 Nov 2011, Claudio Scordino wrote:
> 
>> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
>> index 5861741..80e4645 100644
>> --- a/fs/proc/meminfo.c
>> +++ b/fs/proc/meminfo.c
>> @@ -131,12 +131,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>>   		K(i.freeswap),
>>   		K(global_page_state(NR_FILE_DIRTY)),
>>   		K(global_page_state(NR_WRITEBACK)),
>> -		K(global_page_state(NR_ANON_PAGES)
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +		K(global_page_state(NR_ANON_PAGES)
>>   		  + global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>> -		  HPAGE_PMD_NR
>> +		  HPAGE_PMD_NR),
>> +#else
>> +		K(global_page_state(NR_ANON_PAGES)),
>>   #endif
>> -		  ),
>>   		K(global_page_state(NR_FILE_MAPPED)),
>>   		K(global_page_state(NR_SHMEM)),
>>   		K(global_page_state(NR_SLAB_RECLAIMABLE) +
> 
> Looks like this needs to be fixed for the per-node sysfs meminfo files as
> well?  See node_read_meminfo() in drivers/base/node.c.

Hi David,

	that file cannot be compiled for the cris architecture
(therefore, with the compiler that gave me the error) because
CONFIG_NUMA cannot be defined for the cris architecture.

However, I forced make to build also that file, and actually I got the
same error (i.e., "directives may not be used inside a macro argument").

Since Andrew already took the patch for the meminfo.c file, I'm going to
send a further patch for this specific file.

Let me know if instead you prefer to have a single patch for both files.

Best regards,

	Claudio
