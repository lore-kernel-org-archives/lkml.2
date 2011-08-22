Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1HVCIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 22:08:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49510 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab1HVCID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 22:08:03 -0400
Date: Mon, 22 Aug 2011 03:07:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
Message-ID: <20110822020737.GP2203@ZenIV.linux.org.uk>
References: <20110821063443.GH2203@ZenIV.linux.org.uk>
 <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
 <20110821144352.GJ2203@ZenIV.linux.org.uk>
 <20110821164124.GL2203@ZenIV.linux.org.uk>
 <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
 <20110822011645.GM2203@ZenIV.linux.org.uk>
 <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
 <4E51B56F.3080301@zytor.com>
 <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 10:01:40PM -0400, Andrew Lutomirski wrote:

>  3. We're worried that pt_regs-using compat syscalls might want the
> regs to appear to match the actual arguments (why?)

run strace and you'll see why.

>  4. ptrace expects the "registers" when SYSCALL happens to match the
> int 0x80 convention.  (This is, IMO, sick.)

That's what ptrace is *for*.  It's there to let debuggers play with
the program being debugged, including taking a look at the syscall
arguments and modifying them.  In a predictable way, please.
