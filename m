Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1HWQx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:53:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39509 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1HWQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:53:51 -0400
Date: Tue, 23 Aug 2011 17:53:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@amd64.org>, Andrew Lutomirski <luto@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110823165320.GG2203@ZenIV.linux.org.uk>
References: <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
 <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com>
 <20110823162251.GC13138@aftab>
 <CA+55aFxJF88EJ=WhPq08j4+REBgpvVHVwbg5BR05DD+exRyp8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxJF88EJ=WhPq08j4+REBgpvVHVwbg5BR05DD+exRyp8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 09:29:29AM -0700, Linus Torvalds wrote:

> Oh yes.
> 
> System call performance is *important*. And x86 is *important*.
> 
> UML? In comparison, not that important.
> 
> So quite frankly, if this is purely an UML issue (and unless we're
> missing something else, that's what it looks like, despite all the
> confusion we've had so far), then if we have a choice between "remove
> syscall instruction" and "remove UML", then ...

Agreed.  Note, BTW, that UML has perfectly usable workaround for 99% of
that - don't tell the binaries it has *any* vdso in such cases.  And
"remove UML" turns into "remove support under UML for 32bit binaries
that go out of their way to do SYSCALL directly, which wouldn't work
on native 32bit", which is really a no-brainer.
