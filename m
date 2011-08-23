Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1HWTQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:16:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49371 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1HWTQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:16:44 -0400
Message-ID: <4E53FC6E.1030807@zytor.com>
Date: Tue, 23 Aug 2011 12:15:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Andrew Lutomirski <luto@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com> <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com> <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com> <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk> <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk> <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com> <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com> <20110823162251.GC13138@aftab>
In-Reply-To: <20110823162251.GC13138@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 09:22 AM, Borislav Petkov wrote:
> On Tue, Aug 23, 2011 at 12:11:43PM -0400, Andrew Lutomirski wrote:
>> In any case, this seems insanely overcomplicated.  I'd be less afraid
>> of something like my approach (which, I think, makes all of the
>> SYSCALL weirdness pretty much transparent to ptrace users) or of just
>> removing SYSCALL entirely from 32-bit code.
> 
> I don't think that removing SYSCALL from 32-bit code just so that UML
> trapped syscalls work is something we'd like since SYSCALL is much
> cheaper than INT $0x80:
> 
> "As a result, SYSCALL and SYSRET can take fewer than one-fourth the
> number of internal clock cycles to complete than the legacy CALL and RET
> instructions."
> 
> http://support.amd.com/us/Processor_TechDocs/24593.pdf, p. 152.
> 
> I know, it is 32-bit syscall on 64-bit kernel which should be pretty
> rare but still...
> 

Right, but if you had said the difference had disappeared on current AMD
silicon it would be much less of an issue.  That's why I wanted to find
that bit out from you.
	
	-hpa
