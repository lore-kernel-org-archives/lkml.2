Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab1HWVUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:20:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183Ab1HWVUn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <4E5416CB.7050604@zytor.com>
References: <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com>
 <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <20110823164849.GF2203@ZenIV.linux.org.uk> <CA+55aFxNeK3nx+FTkBpUuENmvwgQzVCTVjZnCW7Wtr6YkPuRgg@mail.gmail.com>
 <4E5416CB.7050604@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Aug 2011 14:20:20 -0700
Message-ID: <CA+55aFy1nR5D73hO6Pkug-FDZ1yCc6Jg5y0VsTkJWzGhD87Bog@mail.gmail.com>
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

On Tue, Aug 23, 2011 at 2:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Again, can we steal one of the padding fields to use for that state
> variable?  We have two 16-bit padding fields; one for cs and one for ss.

We can steal them for passing the information to the user, but no, I
don't think we can use them to then take the information *from* the
user.

Somebody may well be setting up a 'pt_regs' structure on his own, and
simply not fill in the padding, resulting in random data in those
fields.

                     Linus
