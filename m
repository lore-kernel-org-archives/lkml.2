Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1E2P2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 11:28:35 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:65430 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1E2P2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 11:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=Tywnjx/Tm/3wXaRlKV5ZJAmGXFSDd3Ib9U44ISS5FJpTqSz+GRErkNJzrfkq8Uz1us
         4rsQMguXf80J72oObMaDsWTq12pBedyoDl42JJ6YFfdBCX5/QUYbTTRY5q34tf8MiaKp
         NnqP+0lrLa1n4XnmCjXcm5xhhvfkVofVCiTms=
MIME-Version: 1.0
In-Reply-To: <BANLkTikp6EKPXBAWkLa5tHSScOvaWZYy4g@mail.gmail.com>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu> <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
 <BANLkTi=UEJqGxAs5p2tA=KzddNOrXCfXfQ@mail.gmail.com> <BANLkTik7H=HyjzzCf4pYK-K7rx23DGHh8g@mail.gmail.com>
 <BANLkTindgVfP530GDGvonp7iXE=hW833gg@mail.gmail.com> <BANLkTimdne9WVDfooOGcVDtAaG=G4T7uTA@mail.gmail.com>
 <BANLkTimSAyxf2FPN_Z88x=EZwXt0PRwFwQ@mail.gmail.com> <BANLkTim-XGgkNGO+hAkQUsywqA5OKdjzcg@mail.gmail.com>
 <BANLkTikp6EKPXBAWkLa5tHSScOvaWZYy4g@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 11:28:12 -0400
X-Google-Sender-Auth: cpCjtWp9BS0ut5RlkmCA3zutKFc
Message-ID: <BANLkTi=+eGfzfmEG7=ytRzg1skTrCtkCVw@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec5430f3cd1b46104a46bd279
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec5430f3cd1b46104a46bd279
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, May 29, 2011 at 11:10 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Sun, May 29, 2011 at 4:57 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Sun, May 29, 2011 at 5:51 AM, richard -rw- weinberger
>> <richard.weinberger@gmail.com> wrote:
>>> Yesterday I had a closer look at 64bit UML.
>>> Glibc is always using vsyscalls because 64bit UML does not support the =
vDSO.
>>>
>>> On 32bit UML simply scans the ELF auxiliary vector provided by the host=
 to
>>> get the address of the vDSO.
>>> How can I get this address on a 64bit host?
>>
>> I believe it's exactly the same. =A0There's an auxv entry that points to=
 the vDSO.
>
> I don't think so.
> See:
> http://www.win.tue.nl/~aeb/linux/lk/lk-4.html
> Section "Address space randomization".
> The demo program finds the vDSO only on x86.
>
> UML uses quite the same method to find it.
> arch/um/os-Linux/elf_aux.c

The attached program works for me.

I don't know what this is supposed to mean, though:

                                /* See if the page is under TASK_SIZE */
                                if (vsyscall_ehdr < (unsigned long) envp)
                                        vsyscall_ehdr =3D 0;

First, envp !=3D TASK_SIZE.

Second, the vDSO can be wherever it wants.  On current kernels at
least it is *always* mapped below TASK_SIZE (in the unsigned sense)
because it's mapped into user address space.

--Andy

--bcaec5430f3cd1b46104a46bd279
Content-Type: text/x-csrc; charset=US-ASCII; name="auxv.c"
Content-Disposition: attachment; filename="auxv.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_goa56q640

I2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzdGRpby5o
PgojaW5jbHVkZSA8ZWxmLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KCmV4dGVybiBjaGFyICoqZW52
aXJvbjsKCmludCBfX2NhcHR1cmVkX2FyZ2M7CmNoYXIgKipfX2NhcHR1cmVkX2FyZ3Y7CmNoYXIg
KipfX2NhcHR1cmVkX2VudnA7CkVsZjY0X2F1eHZfdCAqX19jYXB0dXJlZF9hdXh2OwoKdm9pZCBf
Y2FwdHVyZV9hcmdzKGludCBhcmdjLCBjaGFyICoqYXJndiwgY2hhciAqKmVudnApCnsKICBfX2Nh
cHR1cmVkX2FyZ2MgPSBhcmdjOwogIF9fY2FwdHVyZWRfYXJndiA9IGFyZ3Y7CiAgX19jYXB0dXJl
ZF9lbnZwID0gZW52cDsKCiAgd2hpbGUoKmVudnApCiAgICBlbnZwKys7CgogIF9fY2FwdHVyZWRf
YXV4diA9IChFbGY2NF9hdXh2X3QqKShlbnZwICsgMSk7Cn0KCnN0YXRpYyB2b2lkICogaW5pdGFy
cmF5X2VudHJ5IF9fYXR0cmlidXRlX18oKHNlY3Rpb24oIi5wcmVpbml0X2FycmF5IiksIHVzZWQp
KSA9CiAgKHZvaWQqKV9jYXB0dXJlX2FyZ3M7CgppbnQgbWFpbigpCnsKICBwcmludGYoImVudnAg
PSAlcFxuIiwgX19jYXB0dXJlZF9lbnZwKTsKCiAgZm9yIChpbnQgaSA9IDA7IF9fY2FwdHVyZWRf
YXV4dltpXS5hX3R5cGUgIT0gQVRfTlVMTDsgaSsrKQogICAgewogICAgICBjaGFyICpkZXNjID0g
IiI7CiAgICAgIGlmIChfX2NhcHR1cmVkX2F1eHZbaV0uYV90eXBlID09IEFUX1NZU0lORk8pCglk
ZXNjID0gIkFUX1NZU0lORk8iOwogICAgICBlbHNlIGlmIChfX2NhcHR1cmVkX2F1eHZbaV0uYV90
eXBlID09IEFUX1NZU0lORk9fRUhEUikKCWRlc2MgPSAiQVRfU1lTSU5GT19FSERSIjsKICAgICAg
cHJpbnRmKCJhdXggdHlwZSAlMDJ1ID0gMHglMDE2bFggJXNcbiIsCgkgICAgIF9fY2FwdHVyZWRf
YXV4dltpXS5hX3R5cGUsIChsb25nKV9fY2FwdHVyZWRfYXV4dltpXS5hX3VuLmFfdmFsLAoJICAg
ICBkZXNjKTsKICAgIH0KICByZXR1cm4gMDsKfQo=
--bcaec5430f3cd1b46104a46bd279--
