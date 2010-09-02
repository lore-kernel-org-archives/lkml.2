Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab0IBQze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:55:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50836 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0IBQzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DJ1RRYIShcijXOMlQtdz0mtwEDDBOO2oJ7T+Jc/SjgjyLGcXL/gxrVyRM/KsIeQ+mV
         Fp/moqPFffclySDXNQm2NquqtkUiPqF+FLo8Nzgd8RlYmS16MjEIlH/WYjlgArqUWRkL
         9L9vard6muOKPiIRc3ZridJK+htVm3HjkL8P4=
MIME-Version: 1.0
In-Reply-To: <4C7FD244.8050502@tilera.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
 <1283442391-23612-23-git-send-email-namhyung@gmail.com> <4C7FD244.8050502@tilera.com>
From: Namhyung Kim <namhyung@gmail.com>
Date: Fri, 3 Sep 2010 01:55:10 +0900
Message-ID: <AANLkTi=kvktxn_03LOAre0ZiRkswwf-O1hg07ZsShEeN@mail.gmail.com>
Subject: Re: [PATCH v2 22/24] ptrace: cleanup arch_ptrace() on tile
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 3, 2010 at 01:35, Chris Metcalf <cmetcalf@tilera.com> wrote:
>  On 9/2/2010 11:46 AM, Namhyung Kim wrote:
>> Remove checking @addr less than 0 because @addr is now unsigned.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>>  arch/tile/kernel/ptrace.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
>> index aed9256..704bf11 100644
>> --- a/arch/tile/kernel/ptrace.c
>> +++ b/arch/tile/kernel/ptrace.c
>> @@ -85,7 +85,7 @@ long arch_ptrace(struct task_struct *child, long request,
>>       case PTRACE_PEEKUSR:  /* Read register from pt_regs. */
>>               if (addr & (sizeof(data)-1))
>>                       break;
>> -             if (addr < 0 || addr >= PTREGS_SIZE)
>> +             if (addr >= PTREGS_SIZE)
>>                       break;
>>               tmp = getreg(child, addr);   /* Read register */
>>               ret = put_user(tmp, datap);
>> @@ -94,7 +94,7 @@ long arch_ptrace(struct task_struct *child, long request,
>>       case PTRACE_POKEUSR:  /* Write register in pt_regs. */
>>               if (addr & (sizeof(data)-1))
>>                       break;
>> -             if (addr < 0 || addr >= PTREGS_SIZE)
>> +             if (addr >= PTREGS_SIZE)
>>                       break;
>>               putreg(child, addr, data);   /* Write register */
>>               ret = 0;
>
> This omits the change to the actual function definition, which was present
> in the previous version of this patch.
>

That change was moved/combined into previous patch in this series.
Please check out 03/24 in this patchset also.


> On the up side, it also removes the change to the sizeof() values in
> GETREGS/SETREGS, which seemed unnecessary in the previous version.
>

Yes, it is unnecessary but little bit more accurate although there will be no
machine that has diferent size of long and unsigned long. Anyway if you
really hate it, I'll discard it. :-)


-- 
Regards,
Namhyung Kim
