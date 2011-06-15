Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1FOF7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 01:59:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48447 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab1FOF72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 01:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tdo5WnctIKE9fwrXLb+hyXKcZyEmO0jyKDf3OzqXp1ruN6obDFSoz9PQ75DXwE7VIG
         RIgYaJBhGNVKj7ZCcZ0Fcbw9sBb81l9JfgvCb9afmZ1Zyuy8yrX/GnWt3rwqWbLWG+J9
         WQfhgKgkouv7NugNY37Su4q/jcVswjHycMO+g=
MIME-Version: 1.0
In-Reply-To: <BANLkTimXYaf_14VbB6ex0kG6sPnTUfzu6g@mail.gmail.com>
References: <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
	<BANLkTi=yEo9fcXW8SqUCtSOag7Mn_+Ni9Q@mail.gmail.com>
	<BANLkTimv6F8NsH0Lg7q6gi1-oiBv8nUrSA@mail.gmail.com>
	<BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
	<BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com>
	<BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com>
	<BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com>
	<4DF7A264.3030901@mit.edu>
	<20110614211613.GB12249@elte.hu>
	<BANLkTi=W1xFdoSFxnNBGX9gt_pYOH4oF=A@mail.gmail.com>
	<20110614213109.GA9725@elte.hu>
	<BANLkTimXYaf_14VbB6ex0kG6sPnTUfzu6g@mail.gmail.com>
Date: Wed, 15 Jun 2011 11:59:27 +0600
Message-ID: <BANLkTi=mwowbSy0M=rjdQW_cKDVf1tBBpA@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 3:33 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Tue, Jun 14, 2011 at 5:31 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>> On Tue, Jun 14, 2011 at 2:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>> >
>>> > I think correctness trumps code size and turning BUG() and BUG_ON()
>>> > into a NOP is just crazy ...
>>>
>>> Umm. It's even CRAZIER to turn it into a "compiler generates random code".
>>
>> Sigh, i assumed it got turned into an infinite loop - that is what
>> i've done in a prior patch.
>>
>> You are right, unreachable() is bogus and you'd also be right to
>> suggest that i should not comment on patches after 11pm ;-)
>
> What we want is a magic GCC trick that says "don't warn about code
> paths that go through here but generate the same code as you would
> without this annotation."  I don't think such a thing exists.
>
No, I don't think we need such kind of thing. I think, we should less
rely on GCC. Here, we need to reconsider the use of BUG. When
vsyscall_nr is default, it hits BUG. Here is the code comment:

               " * If we get here, then vsyscall_nr indicates that int 0xcc
                 * happened at an address in the vsyscall page that doesn't
                 * contain int 0xcc.  That can't happen. "

If that can't happen, I think we can treat it as a FAULT. So, rather
than calling BUG we can ground it into EFAULT. Does it break ABI
compatibility?

Thanks,
Rakib
