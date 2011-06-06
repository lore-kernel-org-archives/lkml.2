Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab1FFIL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:11:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54655 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1FFILy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s47JDooPTOPdl8CFs080tMNHZD6hRPkmbz3OcYMj06qJ8ek9s9C+Yfj7vXDKZbOXao
         hlVMgMondgliGqEr/9xjJ1Cr+cdWPuRLWhgIZIyU49+zi6u5sT4gq3e+OHRRwjG5g2k9
         cmlwRyybtYD5aFsSZ1n+SR+GPd5XatC8X6cJg=
MIME-Version: 1.0
In-Reply-To: <874o43ii1m.fsf@rustcorp.com.au>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
	<fce87f1efab55e15e91b21f1b73f0e86016a27d9.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
	<874o43ii1m.fsf@rustcorp.com.au>
Date: Mon, 6 Jun 2011 10:11:53 +0200
Message-ID: <BANLkTinS67qH-pm2=Z9G1UXk4OOuZNsN9g@mail.gmail.com>
Subject: Re: [PATCH 8/8] arch/x86: use printk_ratelimited instead of printk_ratelimit
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        John Stultz <johnstul@us.ibm.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 8:35 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Sat, 4 Jun 2011 17:37:04 +0200, Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de> wrote:
>> Since printk_ratelimit() shouldn't be used anymore (see comment in
>> include/linux/printk.h), replace it with printk_ratelimited.
>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au> (lguest part)
>
>> diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
>> index db832fd..23a6eff 100644
>> --- a/arch/x86/lguest/boot.c
>> +++ b/arch/x86/lguest/boot.c
>> @@ -56,6 +56,7 @@
>>  #include <linux/lguest_launcher.h>
>>  #include <linux/virtio_console.h>
>>  #include <linux/pm.h>
>> +#include <linux/ratelimit.h>
>>  #include <asm/apic.h>
>>  #include <asm/lguest.h>
>>  #include <asm/paravirt.h>
>
> Is this new include really needed?  The printk_ratelimited() definition
> is in printk.h...

Yes.
printk_ratelimited() needs DEFINE_RATELIMIT_STATE() which is defined
in ratelimit.h.

-- 
Thanks,
//richard
