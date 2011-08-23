Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1HWVJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:09:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60831 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1HWVJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:09:28 -0400
Message-ID: <4E5416CB.7050604@zytor.com>
Date: Tue, 23 Aug 2011 14:08:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Andrew Lutomirski <luto@mit.edu>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com> <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com> <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com> <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk> <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk> <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com> <20110823164849.GF2203@ZenIV.linux.org.uk> <CA+55aFxNeK3nx+FTkBpUuENmvwgQzVCTVjZnCW7Wtr6YkPuRgg@mail.gmail.com>
In-Reply-To: <CA+55aFxNeK3nx+FTkBpUuENmvwgQzVCTVjZnCW7Wtr6YkPuRgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 10:33 AM, Linus Torvalds wrote:
> 
> It would be *nice* if we did the swizzling automatically at setregs()
> time too, but we simply don't have enough information in the kernel to
> do that. Again, exactly because pt_regs doesn't have a "state"
> variable, when user-space does the SETREGS call, we simply don't know
> whether we are in "normal" code or in some system call entry or exit
> state. So the kernel does the swizzling at GETREGS time (by virtue of
> always having the registers in a "canonical" state for system call
> entry), but we fundamentally *cannot* to do the unswizzle, because we
> don't know what the SETREGS caller actually did.
> 

Again, can we steal one of the padding fields to use for that state
variable?  We have two 16-bit padding fields; one for cs and one for ss.

For UML, I agree, let's just not expose the vdso assuming that is
possible, but for other -- possibly future -- users.

	-hpa

