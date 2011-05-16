Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1EPReb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:34:31 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:37427 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1EPRe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Wh+jcKXmfL7a6oWZJcmhwsQK1c9Dccn7sH4tiREJrZyHLcBtlWyO+5qDq5T4IBd2t9
         aKY9PfezKPT1uo29kWEsNTFYORAiYokin7SxWJ0aVEhy0jG7BGx9JXewVH3ayeIvVrIL
         O+mQPHVZ5tE2L5cY8M5wYVM+6HdewEaKj49wk=
MIME-Version: 1.0
In-Reply-To: <20110516172338.GC22383@aftab>
References: <cover.1305560561.git.luto@mit.edu> <5062fb3d104744b00b45afec76bf78e504785370.1305560561.git.luto@mit.edu>
 <20110516172338.GC22383@aftab>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 16 May 2011 13:34:09 -0400
X-Google-Sender-Auth: Z91O1Q0isR1Zw08xDDl7F_cBZs0
Message-ID: <BANLkTikjFnRv-TJYZEuF=6WZ4S-VomDH4w@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] x86-64: Clean up vdso/kernel shared variables
To: Borislav Petkov <bp@amd64.org>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 1:23 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Mon, May 16, 2011 at 12:00:58PM -0400, Andy Lutomirski wrote:
>> Variables that are shared between the vdso and the kernel are
>> currently a bit of a mess.  They are each defined with their own
>> magic, they are accessed differently in the kernel, the vsyscall page,
>> and the vdso, and one of them (vsyscall_clock) doesn't even really
>> exist.
>>
>> This changes them all to use a common mechanism.  All of them are
>> delcared in vvar.h with a fixed address (validated by the linker
>> script).  In the kernel (as before), they look like ordinary
>> read-write variables.  In the vsyscall page and the vdso, they are
>> accessed through a new macro VVAR, which gives read-only access.
>>
>> The vdso is now loaded verbatim into memory without any fixups.  As a
>> side bonus, access from the vdso is faster because a level of
>> indirection is removed.
>>
>> While we're at it, pack jiffies and vgetcpu_mode into the same
>> cacheline.
>
> How about
>
> Signed-off-by:...

Signed-off-by: Andy Lutomirski <luto@mit.edu>

If whoever wants to pick up these patches wants it (or if there's a
v5), I'll send a new patch.

>
> or you don't wanna? :)

Nope.  I probably just hit the delete button too hard or something.

--Andy
