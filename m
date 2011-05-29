Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab1E2O6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 10:58:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35081 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab1E2O6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 10:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=uZW6c3JlIqhQcbNeDMrvLqZRQolakHBOyDXrHCmjFXpbYBuQ0aS5rXxUquPWjsCxJg
         2rasKRiRTzSTQb4X3tZXFmsg0yLsLdqcdYHXMRaNSDolTrSYlqkC/e/KUUsej38Nb2XM
         0fDDkj8ztqow+/Pyi0wP2y+hfdSwDjtT0TflI=
MIME-Version: 1.0
In-Reply-To: <BANLkTimSAyxf2FPN_Z88x=EZwXt0PRwFwQ@mail.gmail.com>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu> <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
 <BANLkTi=UEJqGxAs5p2tA=KzddNOrXCfXfQ@mail.gmail.com> <BANLkTik7H=HyjzzCf4pYK-K7rx23DGHh8g@mail.gmail.com>
 <BANLkTindgVfP530GDGvonp7iXE=hW833gg@mail.gmail.com> <BANLkTimdne9WVDfooOGcVDtAaG=G4T7uTA@mail.gmail.com>
 <BANLkTimSAyxf2FPN_Z88x=EZwXt0PRwFwQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 10:57:51 -0400
X-Google-Sender-Auth: sr7k29iMXHQhWMU7rqXVqLUpU8o
Message-ID: <BANLkTim-XGgkNGO+hAkQUsywqA5OKdjzcg@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 5:51 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Fri, May 27, 2011 at 5:05 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Fri, May 27, 2011 at 10:59 AM, richard -rw- weinberger
>> <richard.weinberger@gmail.com> wrote:
>>> On Fri, May 27, 2011 at 2:10 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>> On Fri, May 27, 2011 at 7:59 AM, richard -rw- weinberger
>>>> If this is considered enough of a regression, then I guess we can
>>>> leave vsyscall64 around for awhile, but it will require extra work in
>>>> the soon-to-be syscall emulation hack to make sure that UML can still
>>>> trap the syscall.
>>>
>>> As long the time within UML is synchronous with the host everything is
>>> fine, right?
>>
>> I think so.  I haven't used UML in a long time.
>>
>>> So, as _last_ choice we could disable the ability to change the time within UML.
>>>
>>> IMHO it's not a big deal when getcpu() returns a wrong CPU layout on UML.
>>>
>>>> The real solution is to fix glibc to use the vDSO which should avoid
>>>> this problem entirely.
>>>
>
> Yesterday I had a closer look at 64bit UML.
> Glibc is always using vsyscalls because 64bit UML does not support the vDSO.
>
> On 32bit UML simply scans the ELF auxiliary vector provided by the host to
> get the address of the vDSO.
> How can I get this address on a 64bit host?

I believe it's exactly the same.  There's an auxv entry that points to the vDSO.

--Andy
