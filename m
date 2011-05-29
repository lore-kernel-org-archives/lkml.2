Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1E2Qki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 12:40:38 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63426 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab1E2Qkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 12:40:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iFzDII5v8IMNd/NgOvw5FaCbDwIiDwdAbyfDkbeRGE/jjDv0NAsbsYnMFHFWfWxNcL
         adc3hmoG0DVXkQ8tyICCPU09emMkXEBlU+es7PKbnQB99gcCt5NO+MdQ5L2V+h59MD1R
         LD6qF55/ZrqorGcXsiXNqBeXWIYCVKpIEaT+g=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=+eGfzfmEG7=ytRzg1skTrCtkCVw@mail.gmail.com>
References: <alpine.LFD.2.02.1105262049180.3078@ionos>
	<4DDEC589.3010201@mit.edu>
	<20110527061208.GB9260@elte.hu>
	<BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
	<BANLkTi=UEJqGxAs5p2tA=KzddNOrXCfXfQ@mail.gmail.com>
	<BANLkTik7H=HyjzzCf4pYK-K7rx23DGHh8g@mail.gmail.com>
	<BANLkTindgVfP530GDGvonp7iXE=hW833gg@mail.gmail.com>
	<BANLkTimdne9WVDfooOGcVDtAaG=G4T7uTA@mail.gmail.com>
	<BANLkTimSAyxf2FPN_Z88x=EZwXt0PRwFwQ@mail.gmail.com>
	<BANLkTim-XGgkNGO+hAkQUsywqA5OKdjzcg@mail.gmail.com>
	<BANLkTikp6EKPXBAWkLa5tHSScOvaWZYy4g@mail.gmail.com>
	<BANLkTi=+eGfzfmEG7=ytRzg1skTrCtkCVw@mail.gmail.com>
Date: Sun, 29 May 2011 18:40:36 +0200
Message-ID: <BANLkTinAawq1SRXO0aK5GiGBVcbJk9sy4Q@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 5:28 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sun, May 29, 2011 at 11:10 AM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Sun, May 29, 2011 at 4:57 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> On Sun, May 29, 2011 at 5:51 AM, richard -rw- weinberger
>>> <richard.weinberger@gmail.com> wrote:
>>>> Yesterday I had a closer look at 64bit UML.
>>>> Glibc is always using vsyscalls because 64bit UML does not support the vDSO.
>>>>
>>>> On 32bit UML simply scans the ELF auxiliary vector provided by the host to
>>>> get the address of the vDSO.
>>>> How can I get this address on a 64bit host?
>>>
>>> I believe it's exactly the same.  There's an auxv entry that points to the vDSO.
>>
>> I don't think so.
>> See:
>> http://www.win.tue.nl/~aeb/linux/lk/lk-4.html
>> Section "Address space randomization".
>> The demo program finds the vDSO only on x86.
>>
>> UML uses quite the same method to find it.
>> arch/um/os-Linux/elf_aux.c
>
> The attached program works for me.

Shouldn't it print the addresses of both AT_SYSINFO and AT_SYSINFO_EHDR?
On my x86_64 system (2.6.37) it seems to find only AT_SYSINFO_EHDR.

> I don't know what this is supposed to mean, though:
>
>                                /* See if the page is under TASK_SIZE */
>                                if (vsyscall_ehdr < (unsigned long) envp)
>                                        vsyscall_ehdr = 0;

See commits a502a359 and 14251809.

>
> First, envp != TASK_SIZE.
>
> Second, the vDSO can be wherever it wants.  On current kernels at
> least it is *always* mapped below TASK_SIZE (in the unsigned sense)
> because it's mapped into user address space.

Hmm, this would explain why UML cannot find it. :-\

-- 
Thanks,
//richard
