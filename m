Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1E2PK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 11:10:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46685 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab1E2PK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 11:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j8461yKs62r15WTcosp/V4jVHqyk3yHUR/l7FhL0c+4XyqRphAVmcnDThopXluoupm
         hYmYS9k3FpnY5WSCbkZVeVP1VmmEsvRJTRpX8/hRd/W2urWXjJfXI2YxkwJuLYLcjFYf
         XPEi2603FA7p7GIXMQUzjuobrRsGHYmMM0uI0=
MIME-Version: 1.0
In-Reply-To: <BANLkTim-XGgkNGO+hAkQUsywqA5OKdjzcg@mail.gmail.com>
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
Date: Sun, 29 May 2011 17:10:55 +0200
Message-ID: <BANLkTikp6EKPXBAWkLa5tHSScOvaWZYy4g@mail.gmail.com>
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

On Sun, May 29, 2011 at 4:57 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sun, May 29, 2011 at 5:51 AM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Fri, May 27, 2011 at 5:05 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> On Fri, May 27, 2011 at 10:59 AM, richard -rw- weinberger
>>> <richard.weinberger@gmail.com> wrote:
>>>> On Fri, May 27, 2011 at 2:10 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>>> On Fri, May 27, 2011 at 7:59 AM, richard -rw- weinberger
>>>>> If this is considered enough of a regression, then I guess we can
>>>>> leave vsyscall64 around for awhile, but it will require extra work in
>>>>> the soon-to-be syscall emulation hack to make sure that UML can still
>>>>> trap the syscall.
>>>>
>>>> As long the time within UML is synchronous with the host everything is
>>>> fine, right?
>>>
>>> I think so.  I haven't used UML in a long time.
>>>
>>>> So, as _last_ choice we could disable the ability to change the time within UML.
>>>>
>>>> IMHO it's not a big deal when getcpu() returns a wrong CPU layout on UML.
>>>>
>>>>> The real solution is to fix glibc to use the vDSO which should avoid
>>>>> this problem entirely.
>>>>
>>
>> Yesterday I had a closer look at 64bit UML.
>> Glibc is always using vsyscalls because 64bit UML does not support the vDSO.
>>
>> On 32bit UML simply scans the ELF auxiliary vector provided by the host to
>> get the address of the vDSO.
>> How can I get this address on a 64bit host?
>
> I believe it's exactly the same.  There's an auxv entry that points to the vDSO.

I don't think so.
See:
http://www.win.tue.nl/~aeb/linux/lk/lk-4.html
Section "Address space randomization".
The demo program finds the vDSO only on x86.

UML uses quite the same method to find it.
arch/um/os-Linux/elf_aux.c

-- 
Thanks,
//richard
