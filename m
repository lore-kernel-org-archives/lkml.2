Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1HWXFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:05:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44894 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab1HWXEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:04:54 -0400
Message-ID: <4E5431F1.6040609@zytor.com>
Date: Tue, 23 Aug 2011 16:04:17 -0700
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
References: <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com> <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com> <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com> <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk> <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk> <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com> <20110823164849.GF2203@ZenIV.linux.org.uk> <CA+55aFxNeK3nx+FTkBpUuENmvwgQzVCTVjZnCW7Wtr6YkPuRgg@mail.gmail.com> <4E5416CB.7050604@zytor.com> <CA+55aFy1nR5D73hO6Pkug-FDZ1yCc6Jg5y0VsTkJWzGhD87Bog@mail.gmail.com>
In-Reply-To: <CA+55aFy1nR5D73hO6Pkug-FDZ1yCc6Jg5y0VsTkJWzGhD87Bog@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 02:20 PM, Linus Torvalds wrote:
> On Tue, Aug 23, 2011 at 2:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> Again, can we steal one of the padding fields to use for that state
>> variable?  We have two 16-bit padding fields; one for cs and one for ss.
> 
> We can steal them for passing the information to the user, but no, I
> don't think we can use them to then take the information *from* the
> user.
> 
> Somebody may well be setting up a 'pt_regs' structure on his own, and
> simply not fill in the padding, resulting in random data in those
> fields.
> 

That would be fine, I'd think... just gives the user space application
enough information to know how it would have to reshuffle the registers
if it needs to.

	-hpa

