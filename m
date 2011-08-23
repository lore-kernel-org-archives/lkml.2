Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1HWTo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:44:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755304Ab1HWToY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:44:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110823194103.GK2203@ZenIV.linux.org.uk>
References: <4E52EF2A.8060608@zytor.com> <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <20110823164849.GF2203@ZenIV.linux.org.uk> <4E53FCF7.7060703@zytor.com>
 <CA+55aFyQTgXD6WeKJLvfOdsgqon=vhnhZ-h9oVpGF1uwQZkdDQ@mail.gmail.com> <20110823194103.GK2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Aug 2011 12:43:28 -0700
Message-ID: <CA+55aFzECeh_xRC=sF7qG_nc3bREqUNXXGmzcLHi4vndFvE6cg@mail.gmail.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Lutomirski <luto@mit.edu>,
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

On Tue, Aug 23, 2011 at 12:41 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> And it's not cheap - doing that on each syscall will be unpleasant...
> Frankly, I'd rather stopped telling the uml userland about vdso in such
> setups.  And anything that plays with SYSCALL outside of vdso... <shrug>
> we already have a "don't run it native on 32bit", adding "don't run
> it on 32bit uml on amd64 host" is not too serious.  At least for now...

I do agree that the solution might well be to just stop using the
non-int80 vdsos for UML. That may just solve everything in practice.

                        Linus
