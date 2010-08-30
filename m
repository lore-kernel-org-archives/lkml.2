Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0H3AoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:44:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34109 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0H3AoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z6VXWvgBj9tulItNRJhQAyKO/eBF6k9CnRZJzHzaZ6fOrni0/Po0AEVRGfwSsCDfOY
         sXYhYQ7B0L+jL+WNCvWiirYUD8l2wxlpCLtyY+1rn2yc621lYSMoPvgCaLT7DevsGcQW
         6JwcFN3fYvZ+eNirEFQYgWTMWroWtZukUC90g=
MIME-Version: 1.0
In-Reply-To: <AANLkTinReUPW4auBZCHVZcHfZfMxEOa1qmaY+npV=UPY@mail.gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-3-git-send-email-brgerst@gmail.com>
	<AANLkTinReUPW4auBZCHVZcHfZfMxEOa1qmaY+npV=UPY@mail.gmail.com>
Date: Sun, 29 Aug 2010 20:44:06 -0400
Message-ID: <AANLkTin6pZq_JquweSMrWfZsCM79v=1TqUConNa85rFN@mail.gmail.com>
Subject: Re: [PATCH 02/11] x86: Merge fpu_init()
From: Brian Gerst <brgerst@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 2:29 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
>> @@ -80,7 +80,6 @@ static void __cpuinit init_thread_xstate(void)
>>  #endif
>>  }
>>
>> -#ifdef CONFIG_X86_64
>>  /*
>>  * Called at bootup to set up the initial FPU state that is later cloned
>>  * into all processes.
>> @@ -88,12 +87,20 @@ static void __cpuinit init_thread_xstate(void)
>>
>>  void __cpuinit fpu_init(void)
>>  {
>> -       unsigned long oldcr0 = read_cr0();
>> +       unsigned long cr0;
>> +       unsigned long cr4_mask = 0;
>>
>> -       set_in_cr4(X86_CR4_OSFXSR);
>> -       set_in_cr4(X86_CR4_OSXMMEXCPT);
>> +       if (cpu_has_fxsr)
>> +               cr4_mask |= X86_CR4_OSFXSR;
>> +       if (cpu_has_xmm)
>> +               cr4_mask |= X86_CR4_OSXMMEXCPT;
>> +       set_in_cr4(cr4_mask);
>
> Is calling set_in_cr4() unconditionally safe for 32-bit CPUs that
> don't have cr4? AFAICT, no, because it uses read_cr4().
>

Good catch, will fix.
--
Brian Gerst
