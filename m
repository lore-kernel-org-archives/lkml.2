Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0ILSgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:36:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24896 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0ILSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:36:18 -0400
Message-ID: <4C8D1D50.600@oracle.com>
Date: Sun, 12 Sep 2010 11:34:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] optprobes: fix kconfig depends/selects
References: <20100812122641.fe88e846.randy.dunlap@oracle.com> <AANLkTimu4zHZrpGkLVQkxsqax1DDefjZXwTn2cxy4WsL@mail.gmail.com>
In-Reply-To: <AANLkTimu4zHZrpGkLVQkxsqax1DDefjZXwTn2cxy4WsL@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/10 03:49, Felipe Contreras wrote:
> On Thu, Aug 12, 2010 at 10:26 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> KALLSYMS and KALLSYMS_ALL depend on DEBUG_KERNEL, so add that dependency.
>> KALLSYMS_ALL depends on KALLSYMS, so select both of them, not just KALLSYMS_ALL.
>>
>> warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc:     Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>> Cc:     "David S. Miller" <davem@davemloft.net>
>> Cc:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>  arch/Kconfig |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> --- linux-next-20100810.orig/arch/Kconfig
>> +++ linux-next-20100810/arch/Kconfig
>> @@ -45,6 +45,8 @@ config OPTPROBES
>>        def_bool y
>>        depends on KPROBES && HAVE_OPTPROBES
>>        depends on !PREEMPT
>> +       depends on DEBUG_KERNEL
>> +       select KALLSYMS
>>        select KALLSYMS_ALL
>>
>>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
>> --
> 
> This causes another problem:
> 
> arch/Kconfig:33:error: recursive dependency detected!
> arch/Kconfig:33:	symbol KPROBES depends on KALLSYMS
> init/Kconfig:825:	symbol KALLSYMS is selected by OPTPROBES
> arch/Kconfig:44:	symbol OPTPROBES depends on KPROBES
> 
> The 'select KALLSYMS' is redundant.
> 
> Otherwise: Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Thanks for checking.  I saw this problem just a day or two ago myself.

Dropping the select does not eliminate the kconfig warning.
I'll try something else.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
