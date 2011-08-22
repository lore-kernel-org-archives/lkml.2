Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1HVNev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:34:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56813 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1HVNes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:34:48 -0400
MIME-Version: 1.0
In-Reply-To: <20110822095336.GB25949@kernel.org>
References: <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk>
 <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
 <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
 <4E51B56F.3080301@zytor.com> <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com>
 <20110822020737.GP2203@ZenIV.linux.org.uk> <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com>
 <4E51D597.3060800@zytor.com> <20110822095336.GB25949@kernel.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 22 Aug 2011 09:34:27 -0400
X-Google-Sender-Auth: UzNXHJ9ldROwQ8huxRmDYUFP4Ok
Message-ID: <CAObL_7F6D8nQovf+aJGiEOF1mBpBU8RwtjNA-5myxvEBRRHgsg@mail.gmail.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 5:53 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * H. Peter Anvin <hpa@zytor.com> wrote:
>
>> Borislav,
>>
>> We're tracking down an issue with the way system call arguments are
>> handled on 32 bits.  We have a solution for SYSENTER but not
>> SYSCALL; fixing SYSCALL "properly" appears to be very difficult at
>> best.
>>
>> So the question is: how much overhead would it be to simply fall
>> back to int $0x80 or some other legacy-style domain crossing
>> instruction for 32-bit system calls on AMD64 processors?  We don't
>> ever use SYSCALL in legacy mode, so native i386 kernels are
>> unaffected.
>
> Last i measured INT80 and SYSCALL costs they were pretty close to
> each other on AMD CPUs - closer than on Intel.

>From memory, SYSCALL in 64-bit mode on Sandy Bridge is much faster
than int 0xcc, which is presumably about the same speed as int 0x80.
That's because SYSCALL is blazingly fast (<30 ns for a whole system
call) and int is slower.

--Andy

>
> Also, most installations are either pure 32-bit or dominantly 64-bit,
> the significantly mixed-mode case is dwindling.
>
> Unifying some more in this area would definitely simplify things ...
>
> Thanks,
>
>        Ingo
>
