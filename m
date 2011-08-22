Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1HVOlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:41:05 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56514 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab1HVOlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:41:03 -0400
Date: Mon, 22 Aug 2011 16:40:51 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@amd64.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110822144051.GD2946@aftab>
References: <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
 <20110822011645.GM2203@ZenIV.linux.org.uk>
 <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
 <4E51B56F.3080301@zytor.com>
 <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com>
 <20110822020737.GP2203@ZenIV.linux.org.uk>
 <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com>
 <4E51D597.3060800@zytor.com>
 <20110822095336.GB25949@kernel.org>
 <CAObL_7F6D8nQovf+aJGiEOF1mBpBU8RwtjNA-5myxvEBRRHgsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAObL_7F6D8nQovf+aJGiEOF1mBpBU8RwtjNA-5myxvEBRRHgsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 09:34:27AM -0400, Andrew Lutomirski wrote:
> On Mon, Aug 22, 2011 at 5:53 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> >
> >> Borislav,
> >>
> >> We're tracking down an issue with the way system call arguments are
> >> handled on 32 bits.  We have a solution for SYSENTER but not
> >> SYSCALL; fixing SYSCALL "properly" appears to be very difficult at
> >> best.
> >>
> >> So the question is: how much overhead would it be to simply fall
> >> back to int $0x80 or some other legacy-style domain crossing
> >> instruction for 32-bit system calls on AMD64 processors?  We don't
> >> ever use SYSCALL in legacy mode, so native i386 kernels are
> >> unaffected.
> >
> > Last i measured INT80 and SYSCALL costs they were pretty close to
> > each other on AMD CPUs - closer than on Intel.
> 
> From memory, SYSCALL in 64-bit mode on Sandy Bridge is much faster
> than int 0xcc, which is presumably about the same speed as int 0x80.
> That's because SYSCALL is blazingly fast (<30 ns for a whole system
> call) and int is slower.

Just to make sure I'm grokking this correctly - we want to use int $0x80
only for the SYSCALL variant in __kernel_vsyscall, right? Not for all
32-bit syscalls on a 64-bit kernel.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
