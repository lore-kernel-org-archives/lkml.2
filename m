Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab1EWSfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:35:42 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48378 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab1EWSfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CCo3B9JWrzKyVUPrby1yMLzItMCOzUFolrweGg0oXLQtJhOho+3wfaXGBylhwaf4m/
         vUH4FJJMcCezyXx3WgzyrZsnEJ+o/yJd4WanwimivJe43M/O8mdNBLM1oCIx6ftOnzou
         wyob3JhpFCnSKJgY2RT93+gors4eXxruIZozA=
Message-ID: <4DDAA8F8.90605@gmail.com>
Date: Mon, 23 May 2011 22:35:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH -next] x86: apic_flat_64.c needs module.h
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au> <20110523104300.dd532a99.randy.dunlap@oracle.com> <4DDA9EAB.40304@gmail.com> <4DDAA2C0.7080108@gmail.com> <4DDAA384.2000203@oracle.com>
In-Reply-To: <4DDAA384.2000203@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 10:12 PM, Randy Dunlap wrote:
> On 05/23/11 11:09, Cyrill Gorcunov wrote:
>> On 05/23/2011 09:51 PM, Cyrill Gorcunov wrote:
>>> On 05/23/2011 09:43 PM, Randy Dunlap wrote:
>>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>>
>>>> apic_flat_64.c needs to include module.h to fix these warnings:
>>>>
>>>> arch/x86/kernel/apic/apic_flat_64.c:31: warning: data definition has no type or storage class
>>>> arch/x86/kernel/apic/apic_flat_64.c:31: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
>>>> arch/x86/kernel/apic/apic_flat_64.c:31: warning: parameter names (without types) in function declaration
>>>>
>>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>> ---
>>>>  arch/x86/kernel/apic/apic_flat_64.c |    1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> --- linux-next-20110523.orig/arch/x86/kernel/apic/apic_flat_64.c
>>>> +++ linux-next-20110523/arch/x86/kernel/apic/apic_flat_64.c
>>>> @@ -16,6 +16,7 @@
>>>>  #include <linux/ctype.h>
>>>>  #include <linux/init.h>
>>>>  #include <linux/hardirq.h>
>>>> +#include <linux/module.h>
>>>>  #include <asm/smp.h>
>>>>  #include <asm/apic.h>
>>>>  #include <asm/ipi.h>
>>>
>>> Thanks Randy! For some reason I didn't hit this problem while
>>> were compiling the kernel and testing it (I usually do not use
>>> modules though).
>>>
>>> I've CC'ed Ingo and Suresh.
>>>
>>
>> Randy, while adding module.h here is correct I fail to see why I didn't
>> hit this problem before, could you please post your config?
> 
> Certainly, it's attached.  It's a randconfig file.
> I saw this build error on roughly 5 out of 15 randconfig builds.
> 
> CONFIG_SMP is disabled...
> 
> 
> Thanks.
> 
> 

  CONFIG_SMP seems to be the point, unweaving headers deps backward is not
that convenient task, probably there is kinda automation tools exist? I
have a gut feeling I saw something but can't remember where exactly ;)

-- 
    Cyrill
