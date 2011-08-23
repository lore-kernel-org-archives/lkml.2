Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1HWAXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:23:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab1HWAXH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:23:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E52EF2A.8060608@zytor.com>
References: <4E51D597.3060800@zytor.com> <20110822095336.GB25949@kernel.org>
 <CAObL_7F6D8nQovf+aJGiEOF1mBpBU8RwtjNA-5myxvEBRRHgsg@mail.gmail.com>
 <20110822144051.GD2946@aftab> <20110822151305.GV2203@ZenIV.linux.org.uk>
 <CA+55aFwoRO9xxnTyt_gYFdTS9LsaFoCWRuyNeXY7gvrE8CdZ0A@mail.gmail.com>
 <4E52B7F8.3050002@zytor.com> <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
 <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com>
 <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 22 Aug 2011 17:22:07 -0700
Message-ID: <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Lutomirski <luto@mit.edu>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 5:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Checking for SYSCALL in the vdso is cheap... the only problem is if
> someone thinks that they can copy it out of the vdso and run it, having
> special-cased SYSENTER already, but not SYSCALL.  The recent experience
> shows that that is apparently a very real possibility.

I don't understand why people keep harping on this "copy the vdso" thing.

Guys, IF THEY COPY THE VDSO, THEN THEY WOULD GET OUR IMPROVEMENTS!

So stop being silly.

As to comparing the IP address, that's just moronic. Why the hell
would anybody ever do something that stupid? It's expensive and not
worth it. You'd be much better off comparing the contents of the
memory at 'rip', and see if that memory contains the 'int 0x80'
instruction we would add. That automatically also gets the 'somebody
copied the vdso text' case right.

You guys seem to positively _want_ to make this a bigger issue than it
is. As far as I can tell, nobody has ever even noticed this problem
before, and we already have a trivial fix ("don't do it then") for the
case Al actually did notice.

The *only* case left as far as I can tell is the case where people do
*not* copy the vdso, but simply generate (statically and/or
dynamically with a JIT) the syscall instruction directly. And we
cannot fix that, so stop even bothering to try. The absolute best we
can do for that case is to just continue to do what we do now. WE
SIMPLY HAVE NO CHOICE.

I really don't see this as being worth this much discussion.

                     Linus
