Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0FGBYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:24:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50752 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab0FGBYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C4dOr66kTwhrG2MSEH/GZ1wQ1QvsiByN0ICLn2DfuX97eV5AnDmLSNzzZViE9hGuLB
         mLvb3JD1jQJdR53RxGOJ24/fTtY5ariBtiO4138euWfPNFL/0Hfo6w3iKHJfC9rZoqUn
         IzAVoXJurfpeJ0rb7RF8PuJkSP4Mj7WugFC8U=
MIME-Version: 1.0
In-Reply-To: <4C0C47A8.1000800@orcon.net.nz>
References: <4C0C22C4.3010705@orcon.net.nz>
	<AANLkTim9aWVzb7v5fnS6x3ghMU2_tpaLlbZu3SKXV_0R@mail.gmail.com>
	<4C0C47A8.1000800@orcon.net.nz>
Date: Sun, 6 Jun 2010 21:24:03 -0400
Message-ID: <AANLkTinnprvU7bbe28emifv766_tWKjaSfW0ch2PQY23@mail.gmail.com>
Subject: Re: 2.6.35-rc2 compilation error on Alpha
From: Matt Turner <mattst88@gmail.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 9:13 PM, Michael Cree <mcree@orcon.net.nz> wrote:
> On 07/06/10 12:08, Matt Turner wrote:
>>
>> On Sun, Jun 6, 2010 at 6:35 PM, Michael Cree<mcree@orcon.net.nz>  wrote:
>>>
>>> When compiling 2.6.35-rc2 for Alpha architecture the following compiler
>>> error is seen:
>>>
>>>  CC      arch/alpha/kernel/asm-offsets.s
>>> In file included from include/linux/kernel.h:17,
>>>                 from include/linux/sched.h:54,
>>>                 from arch/alpha/kernel/asm-offsets.c:9:
>>> include/linux/bitops.h: In function ‘hweight_long’:
>>> include/linux/bitops.h:49: error: implicit declaration of function
>>> ‘__arch_hweight32’
>>
>> Yeah, it was a stupid typo in
>> 1527bc8b928dd1399c3d3467dd47d9ede210978a. I've fixed it and put the
>> patch in my tree for Linus.
>
> Ah, now the offending commit is pointed out to me I can see the trivial fix.
>  With that, as you say, compilation now bombs out in the pci-sysfs stuff.
>  Since you claim to have that in hand I'll await your solution.
>
> Cheers
> Michael.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-alpha" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Fixes for both breaks are in:
   git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git
for-linus

I know alpha hardware isn't easy to get your hands on to compile test
these changes, but guys, please just send linux-alpha@ the patch and
_I'll_ do it. Both these breaks were not even compile tested.

pci break: 2c3c8bea608866d8bd9dcf92657d57fdcac011c5
hweight break: 1527bc8b928dd1399c3d3467dd47d9ede210978a

Greg, I haven't checked, but if either of these commits are in .34 or
older, then my fixes need to go into -stable.

Thanks,
Matt
