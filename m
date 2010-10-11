Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0JKRFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:05:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22384 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab0JKRF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:05:29 -0400
Message-ID: <4CB343BD.9030605@oracle.com>
Date: Mon, 11 Oct 2010 10:05:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 1 (hwmon/pkgtemp)
References: <20101001153756.47b52566.sfr@canb.auug.org.au> <20101001154314.9db0062c.randy.dunlap@oracle.com> <20101004184445.GA31377@linux-os.sc.intel.com>
In-Reply-To: <20101004184445.GA31377@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/10 11:44, Fenghua Yu wrote:
> On Fri, Oct 01, 2010 at 03:43:14PM -0700, Randy Dunlap wrote:
>> On Fri, 1 Oct 2010 15:37:56 +1000 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20100930:
>>
>>
>> drivers/hwmon/pkgtemp.c:356: error: implicit declaration of function 'cpu_core_mask'
>>
>> CONFIG_SMP is not set.
>>
>> config is attached.
>>
> 
> From: Fenghua Yu <fenghua.yu@intel.com>
> Date: Mon, 4 Oct 2010 11:00:36 -0700
> Subject: [PATCH] hwmon (pkgtemp): Fix build failure for UP
> 
> This fix is only a workaround. Another fix is to add #ifdef CONFIG_SMP around
> cpu_core_mask. But the code will not be cleaner than this fix.  This fix is
> similar to coretemp in commit fff2017354a3a9906862aabbf2a1cae5b4330e40.
> 
> For a real fix, cpu_core_mask() should be defined in UP include code, eg in
> linux/smp.h, and asm/smp.h should not be included directly. This fix is
> currently not possible because asm/smp.h define cpu_core_mask() unconditionally
> and is included directly from many source files.
> 
> In the long run, both cpu_sibling_mask and cpu_core_mask will be defined in UP
> and this workaround and the workaround in coretemp can be removed.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  drivers/hwmon/pkgtemp.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
> index c9f652d..36d96c7 100644
> --- a/drivers/hwmon/pkgtemp.c
> +++ b/drivers/hwmon/pkgtemp.c
> @@ -32,6 +32,7 @@
>  #include <linux/list.h>
>  #include <linux/platform_device.h>
>  #include <linux/cpu.h>
> +#include <asm/smp.h>
>  #include <asm/msr.h>
>  #include <asm/processor.h>
>  


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
