Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab1FABiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:38:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64733 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192Ab1FABiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PtglhxGIIRu95ezrRV0WRL0H6SW0bFN+SnO5VVfhGy41o3QkTnSkZmanfz9kE7sMih
         2g19C9ZRuV4wiYwrNho766CRWwVfPtV0MXR8+9A5rPxy/Ez3u3aervpHmyKSNLCcpMB0
         xyu0fjmhju7MoHhmAlFRGXpvv0iPYVRXz9zpg=
MIME-Version: 1.0
In-Reply-To: <BANLkTinC=bL6NvRzU2hrFLgmbyFu6L-8zA@mail.gmail.com>
References: <BANLkTinC=bL6NvRzU2hrFLgmbyFu6L-8zA@mail.gmail.com>
Date: Tue, 31 May 2011 21:38:15 -0400
Message-ID: <BANLkTi=c7m3RTQb5dn+kcTt1HmkGb730hg@mail.gmail.com>
Subject: Re: Question about alternatives (Re: [PATCH 0/5] x86-64: Remove
 syscall instructions at fixed addresses)
From: Brian Gerst <brgerst@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:31 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Tue, May 31, 2011 at 9:17 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Tue, May 31, 2011 at 9:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> * Andrew Lutomirski <luto@mit.edu> wrote:
>>>
>>>> > You could start with picking the more compatible alternative
>>>> > instruction initially. I don't at all mind losing half a cycle of
>>>> > performance in that case ... this code should be secure first.
>>>>
>>>> The more compatible one is mfence, which in some cases could (I
>>>> think) be a lot more than half a cycle.
>>>
>>> I'd still suggest to do the mfence change now and remove the
>>> alternatives patching for now - if it's more than half a cycle then
>>> it sure will be implemented properly, right?
>>
>> I don't know.  I just cut 5 ns off the thing a couple weeks ago and no
>> one beat me to it :)
>>
>> I'll take a look at how hard the patching will be.
>
> I don't think it'll be that hard to get the alternatives code to work
> on the vdso, but there's an annoyance: the alt_instr descriptor
> contains the absolute addresses of the old and new code.  That means
> that if we generate a shared object with alternatives, that shared
> object will contain relocations, and I'd rather not teach the kernel
> how to relocate the vdso image.

Alternatives in the vdso won't work without special support, since it
is encapsulated as a binary blob in the kernel (so its
.altinstructions section won't get merged with the kernel's).  You
will need to add code to parse the vdso's ELF headers and apply the
alternatives to the kernel's image of the vdso.  It looks like the
32-bit vdso already has some code to parse and apply relocations to
the ELF headers so that could possibly be a starting point.

--
Brian Gerst
