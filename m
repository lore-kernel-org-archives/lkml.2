Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1HWTSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:18:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49429 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab1HWTSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:18:48 -0400
Message-ID: <4E53FCF7.7060703@zytor.com>
Date: Tue, 23 Aug 2011 12:18:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <luto@mit.edu>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com> <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com> <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com> <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk> <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk> <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com> <20110823164849.GF2203@ZenIV.linux.org.uk>
In-Reply-To: <20110823164849.GF2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 09:48 AM, Al Viro wrote:
> 
> Um...  How would it know which syscall variant had that been, to start
> with?  For int 0x80 it would need to use registers as-is.  For SYSENTER
> it also could use them as-is - ebp will differ from what we put there
> when entering the sucker, but not critically so; on the way out of
> syscall we'll overwrite it anyway immediately (either by pop or mov).
> For SYSCALL... we don't really care about ecx contents prior to entering
> the kernel (and it'll be blown out anyway), and ebp one could be found in
> regs.ecx.  So yes, we can do it that way, but... how to tell what variant
> had been triggered?  Examining two bytes prior to user eip?  Sounds bloody
> brittle...

We could drop that information in a metaregister.  It's not backward
compatible, but at least it will be obvious when that information is
available and not.

	-hpa
