Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1FLFMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 01:12:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59377 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1FLFMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 01:12:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g29ICN8a4pwSoMi8wwrUHKqe7xa4SKiRiC9sf1IUYWRXllIkBLvSWq2CAK4paZ+nls
         JuJlhOBnDZoP3kH44YFKp6t6LZ9Zf5+Z6sBiLuR3qznpdluVCHn4K+4NyfjakQbJY/SB
         f+7f+08slzsx04Wtuc7Bm8Wcda33VuemT3FMA=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
References: <1307777464.25182.3.camel@localhost.localdomain>
	<BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
Date: Sun, 12 Jun 2011 11:12:37 +0600
Message-ID: <BANLkTi=yEo9fcXW8SqUCtSOag7Mn_+Ni9Q@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 5:01 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> Due to commit 5cec93c216db77 (x86-64: Emulate legacy vsyscalls), we get the following warning:
>>
>>   arch/x86/kernel/vsyscall_64.c: In function ‘do_emulate_vsyscall’:
>>   arch/x86/kernel/vsyscall_64.c:111:7: warning: ‘ret’ may be used uninitialized in this function
>
> What's the code path that uses ret without initializing it?
>
In case of, vsyscall_nr is default it might gets uninitialized. And
current code already treats it as a bug.

>> -       if (ret == -EFAULT) {
>> +       if (ret == -EFAULT || ret == -EINVAL) {
>>                /*
>>                 * Bad news -- userspace fed a bad pointer to a vsyscall.
>>                 *
>
> EINVAL doesn't seem like grounds to fault.  (I'm not sure how to get
> EINVAL from time, gettimeofday, or getcpu, but in case there is, we
> should return it back to userspace.)
>
If ret = EINVAL, then it means vsyscall_nr doesn't any of
gettimeofday, time or getcpu. So, I grounds it into fault. In case of
gettimeofday, EINVAL may gets return. But, maybe not in case of time
or getcpu. So, maybe we need to check EINVAL in case of gettimeofday
and maybe should separate EINVAL and EFAULT.

Thanks,
Rakib
> --Andy
>
