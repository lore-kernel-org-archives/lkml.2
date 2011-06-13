Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1FMIpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:45:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40246 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1FMIpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VL75/V9Zz5tUy4SJZA7VXY2Pey+HtScPB9MNCA96samTP8V3dq3P2ELXOk7wB3R5/3
         ZfzLFhEJBYXCgksOerycBPMmdFk3dxpMb1l+Kks4Qwr8ceMm/5o2YFgWS/mSFtkyh9Kc
         v6ptf7TMjvjGVE40iJ7ZQkkUoFi2ppuukwh/k=
MIME-Version: 1.0
In-Reply-To: <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
References: <1307777464.25182.3.camel@localhost.localdomain>
	<BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
	<BANLkTi=yEo9fcXW8SqUCtSOag7Mn_+Ni9Q@mail.gmail.com>
	<BANLkTimv6F8NsH0Lg7q6gi1-oiBv8nUrSA@mail.gmail.com>
	<BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
Date: Mon, 13 Jun 2011 14:45:14 +0600
Message-ID: <BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 10:54 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Mon, Jun 13, 2011 at 8:52 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Sun, Jun 12, 2011 at 1:12 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>> On Sat, Jun 11, 2011 at 5:01 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>> On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>
>> I think there are three separate issues here:
>>
>> 1. Can ret be used uninitialized?  I say no, even as seen by the
>> compiler.  If vsyscall_nr is 0, 1, or 2, then ret is initialized.  If
>> vsyscall_nr is 3, then the BUG gets hit.  BUG is defined as some
>> assembly magic followed by unreachable(), and the compiler is supposed
>> to know that code after unreachable() is qunreachable.  So how can ret
>> be used uninitialized?
>>
> I don't have much knowledge of advance assembly, so I really don't
> understand that part - how BUG handles this. If it really makes sure
> that, it will handle it properly then I think you can drop this patch.
>
>> What version of gcc do you have?  gcc (GCC) 4.6.0 20110530 (Red Hat
>> 4.6.0-9) does not produce this warning.
>>
> Currently, I'm replying from outside my home. I'll let you know when
> I'm back home.
>
Here is my GCC version - gcc version 4.5.1 20100924 (Red Hat 4.5.1-4)
(GCC). I'm using Fedora 14.

Thanks,
Rakib
