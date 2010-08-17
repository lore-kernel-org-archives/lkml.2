Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab0HQPEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:04:04 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39909 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0HQPEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:04:02 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Aug 2010 11:04:02 EDT
X-AuditID: b753bd60-a82c0ba000005a63-9b-4c6aa4df7406
Message-ID: <4C6AA4DC.8090307@hitachi.com>
Date: Wed, 18 Aug 2010 00:03:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] optprobes: fix kconfig depends/selects
References: <20100812122641.fe88e846.randy.dunlap@oracle.com> <4C6AA2DF.5020301@hitachi.com>
In-Reply-To: <4C6AA2DF.5020301@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> KALLSYMS and KALLSYMS_ALL depend on DEBUG_KERNEL, so add that dependency.
>> KALLSYMS_ALL depends on KALLSYMS, so select both of them, not just KALLSYMS_ALL.
> 
> Indeed, Thanks for pointing it!
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Oops, I meant;
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Sorry:(
> 
>> warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc:	Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc:	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>> Cc:	"David S. Miller" <davem@davemloft.net>
>> Cc:	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>  arch/Kconfig |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> --- linux-next-20100810.orig/arch/Kconfig
>> +++ linux-next-20100810/arch/Kconfig
>> @@ -45,6 +45,8 @@ config OPTPROBES
>>  	def_bool y
>>  	depends on KPROBES && HAVE_OPTPROBES
>>  	depends on !PREEMPT
>> +	depends on DEBUG_KERNEL
>> +	select KALLSYMS
>>  	select KALLSYMS_ALL
>>  
>>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
> 
> 

