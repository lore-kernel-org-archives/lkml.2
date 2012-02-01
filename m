Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2BAHgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:36:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2BAHgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:36:45 -0500
Message-ID: <4F28EC26.8010604@redhat.com>
Date: Wed, 01 Feb 2012 15:39:18 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
References: <20120201063420.GA10204@darkstar.nay.redhat.com> <4F28DF9B.40702@gmail.com>
In-Reply-To: <4F28DF9B.40702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 02:45 PM, Cong Wang wrote:

> On 02/01/2012 02:34 PM, Dave Young wrote:
>> tools/ is the better place for vm tools which are used by many people.
>> Moving them to tools also make them open to more users instead of hide in
>> Documentation folder.
> 
> Well, hugepage-mmap, hugepage-shm, and map_hugetlb are examples, not
> really tools. So, only page-types is probably a tool, but I leave this
> to Fengguang to decide.


looks reasonable

> 
>>
>> Also fixed several coding style problem.
> 
> Make it another patch for people to review. :)


Will do

> 
> [...]
>> diff --git a/tools/vm/Makefile b/tools/vm/Makefile
>> new file mode 100644
>> index 0000000..b4f9fdd
>> --- /dev/null
>> +++ b/tools/vm/Makefile
>> @@ -0,0 +1,11 @@
>> +# Makefile for vm tools
>> +
>> +CC = $(CROSS_COMPILE)gcc
>> +CFLAGS = -Wall -Wextra
>> +
>> +all: page-types hugepage-mmap hugepage-shm map_hugetlb
>> +%: %.c
>> +    $(CC) $(CFLAGS) -o $@ $^
>> +
>> +clean:
>> +    $(RM) page-types hugepage-mmap hugepage-shm map_hugetlb
> 
> Is $(RM) defined?


It's a predefined variables of GNU makefile, It Imply rule of 'rm -f'

-- 
Thanks
Dave
