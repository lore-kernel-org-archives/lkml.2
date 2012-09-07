Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab2IGKCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 06:02:19 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:58764 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760313Ab2IGKCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 06:02:18 -0400
Message-ID: <5049C5F1.3050301@in.ibm.com>
Date: Fri, 07 Sep 2012 15:31:21 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@lists.ozlabs.org, mahesh@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] [powerpc] Change memory_limit from phys_addr_t
 to unsigned long long
References: <20120821113815.29282.4000.stgit@suzukikp.in.ibm.com> <20120821114225.29282.87841.stgit@suzukikp.in.ibm.com> <1346981712.2385.30.camel@pasglop>
In-Reply-To: <1346981712.2385.30.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12090710-5816-0000-0000-000004557B8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 07:05 AM, Benjamin Herrenschmidt wrote:
> On Tue, 2012-08-21 at 17:12 +0530, Suzuki K. Poulose wrote:
>> There are some device-tree nodes, whose values are of type phys_addr_t.
>> The phys_addr_t is variable sized based on the CONFIG_PHSY_T_64BIT.
>>
>> Change these to a fixed unsigned long long for consistency.
>>
>> This patch does the change only for memory_limit.
>>
>> The following is a list of such variables which need the change:
>>
>>   1) kernel_end, crashk_size - in arch/powerpc/kernel/machine_kexec.c
>>
>>   2) (struct resource *)crashk_res.start - We could export a local static
>>      variable from machine_kexec.c.
>>
>> Changing the above values might break the kexec-tools. So, I will
>> fix kexec-tools first to handle the different sized values and then change
>>   the above.
>>
>> Suggested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
>> ---
>
> Breaks the build on some configs (with 32-bit phys_addr_t):

Sorry for that.
>
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/prom.c: In function
> 'early_init_devtree':
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/prom.c:664:25: error:
> comparison of distinct pointer types lacks a cast
>
> I'm fixing that myself this time but please be more careful.
Sure. Thanks Ben for fixing that.

Suzuki

