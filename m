Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1HWBTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 21:19:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34462 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1HWBTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 21:19:10 -0400
Message-ID: <4E52FFD7.8080009@zytor.com>
Date: Mon, 22 Aug 2011 18:18:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <20110822144051.GD2946@aftab> <20110822151305.GV2203@ZenIV.linux.org.uk> <CA+55aFwoRO9xxnTyt_gYFdTS9LsaFoCWRuyNeXY7gvrE8CdZ0A@mail.gmail.com> <4E52B7F8.3050002@zytor.com> <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com> <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com> <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com> <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com> <20110823010146.GY2203@ZenIV.linux.org.uk> <CAObL_7FG8eFTZ4djKH0T8tbRf2h6+iOm=OXr8194nvzc+w+a9A@mail.gmail.com>
In-Reply-To: <CAObL_7FG8eFTZ4djKH0T8tbRf2h6+iOm=OXr8194nvzc+w+a9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 06:16 PM, Andrew Lutomirski wrote:
> 
> I suspect that very few things care whether syscall arguments get
> clobbered.  The only way it would matter is if gcc reuses the argument
> in the ecx slot after an inlined syscall later in the same function. 
> Any code that does that is already wrong if the syscall restarts with
> changed ecx or if something like UML changes the syscall argument.
> 

No, the glibc wrapper for the system call Al was looking at used %ecx to
hold a copy of the PIC pointer (normally %ebx)!

	-hpa

