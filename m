Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0ILSlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:41:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37079 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0ILSlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xob49UEgKYFh89LT3vhH4C0OVpq2v2+UGWXJREmrJPfjiaa+amk8s9RyQ1Rp8CVy+h
         6R7g2/NoG+RCWZmkFhhy8nurJZf5gA0Os2toxtaDBPPvKdABLt08M/CNoGKu9O7uTvCL
         ICS7U0z6Eg/dO4bFodm7e/TdFOWkMMqJR5UJM=
MIME-Version: 1.0
In-Reply-To: <4C8D1D50.600@oracle.com>
References: <20100812122641.fe88e846.randy.dunlap@oracle.com>
	<AANLkTimu4zHZrpGkLVQkxsqax1DDefjZXwTn2cxy4WsL@mail.gmail.com>
	<4C8D1D50.600@oracle.com>
Date: Sun, 12 Sep 2010 21:41:07 +0300
Message-ID: <AANLkTikL0JEiWjms9DPYK=jfNmOP78HC7qu+deO5+dP6@mail.gmail.com>
Subject: Re: [PATCH -next] optprobes: fix kconfig depends/selects
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 9:34 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 09/12/10 03:49, Felipe Contreras wrote:
>> On Thu, Aug 12, 2010 at 10:26 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> KALLSYMS and KALLSYMS_ALL depend on DEBUG_KERNEL, so add that dependency.
>>> KALLSYMS_ALL depends on KALLSYMS, so select both of them, not just KALLSYMS_ALL.
>>>
>>> warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>> Cc:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>>> Cc:     Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>>> Cc:     "David S. Miller" <davem@davemloft.net>
>>> Cc:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>> ---
>>>  arch/Kconfig |    2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> --- linux-next-20100810.orig/arch/Kconfig
>>> +++ linux-next-20100810/arch/Kconfig
>>> @@ -45,6 +45,8 @@ config OPTPROBES
>>>        def_bool y
>>>        depends on KPROBES && HAVE_OPTPROBES
>>>        depends on !PREEMPT
>>> +       depends on DEBUG_KERNEL
>>> +       select KALLSYMS
>>>        select KALLSYMS_ALL
>>>
>>>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
>>> --
>>
>> This causes another problem:
>>
>> arch/Kconfig:33:error: recursive dependency detected!
>> arch/Kconfig:33:      symbol KPROBES depends on KALLSYMS
>> init/Kconfig:825:     symbol KALLSYMS is selected by OPTPROBES
>> arch/Kconfig:44:      symbol OPTPROBES depends on KPROBES
>>
>> The 'select KALLSYMS' is redundant.
>>
>> Otherwise: Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>
> Thanks for checking.  I saw this problem just a day or two ago myself.
>
> Dropping the select does not eliminate the kconfig warning.
> I'll try something else.

Huh? The original warning is gone by just adding 'depends on DEBUG_KERNEL'.

-- 
Felipe Contreras
