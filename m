Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab1E2UFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:05:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61508 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab1E2UFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=WhrIDvb8FooY/UVE/ffKNPheUgDLoafkk2wBC4aK8WP/Hfbe1ClDKAcBZDdnPJGbnY
         HR8w6ZByCxHiiGT9/cnMf4EogxnbrYvX9vMjwrVR4kgUAgq4qo4glyz1uWB4EZi8+Xog
         kpytS/exEty56Wi/BSLLA8cvTUafGncDwOVa8=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1105292152310.4411@swampdragon.chaosbits.net>
References: <cover.1306517576.git.luto@mit.edu> <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
 <alpine.LNX.2.00.1105292146470.4411@swampdragon.chaosbits.net> <alpine.LNX.2.00.1105292152310.4411@swampdragon.chaosbits.net>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 16:05:00 -0400
X-Google-Sender-Auth: DWV_Y6fIK8jkEYfKVgePhffQYgg
Message-ID: <BANLkTinF1SGtFK+Khba4fAaox1Ran1KTtA@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
To: Jesper Juhl <jj@chaosbits.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 3:54 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Sun, 29 May 2011, Jesper Juhl wrote:
>
>> On Fri, 27 May 2011, Andy Lutomirski wrote:
>>
>> > Now the only way to issue a syscall with side effects through the
>> > vsyscall page is to call a misaligned instruction.  I haven't
>> > checked for that.
>> >
>> > Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> > ---
>> >  arch/x86/include/asm/traps.h    |    4 +++
>> >  arch/x86/include/asm/vsyscall.h |    6 +++++
>> >  arch/x86/kernel/entry_64.S      |    2 +
>> >  arch/x86/kernel/traps.c         |    4 +++
>> >  arch/x86/kernel/vsyscall_64.c   |   47 ++++++++++++++++++++++++++++++++++-----
>> >  5 files changed, 57 insertions(+), 6 deletions(-)
>> >
>>
>> one very tiny nit below.
>>
>> [...]
>> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
>> > index b9b6716..d34894e 100644
>> > --- a/arch/x86/kernel/traps.c
>> > +++ b/arch/x86/kernel/traps.c
>> > @@ -872,6 +872,10 @@ void __init trap_init(void)
>> >     set_bit(SYSCALL_VECTOR, used_vectors);
>> >  #endif
>> >
>> > +   set_system_intr_gate(0xCC, &intcc);
>> > +   set_bit(0xCC, used_vectors);
>> > +   printk(KERN_ERR "intcc gate isntalled\n");
>>
>> Let's spell the error message correctly:
>>
>>       printk(KERN_ERR "intcc gate installed\n");
>>
> Hmm, why is this KERN_ERR btw? Shouldn't it just be KERN_NOTICE or
> KERN_INFO ?

IMO it shouldn't be there at all.  It was a debugging leftover that I
forgot to delete.

--Andy
