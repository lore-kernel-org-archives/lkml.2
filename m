Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1HUOoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:44:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab1HUOoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:44:11 -0400
Date: Sun, 21 Aug 2011 15:43:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
Message-ID: <20110821144352.GJ2203@ZenIV.linux.org.uk>
References: <4E4E2427.9080602@nod.at>
 <20110820011845.GC2203@ZenIV.linux.org.uk>
 <4E4FD12F.70508@nod.at>
 <20110820201406.GF2203@ZenIV.linux.org.uk>
 <4E501F51.9060905@nod.at>
 <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
 <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
 <20110821063443.GH2203@ZenIV.linux.org.uk>
 <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 07:24:35AM -0400, Andrew Lutomirski wrote:

> I don't see the point of all this hackery at all.  sysenter/sysexit
> indeed screws up some registers, but we can return on the iret path in
> the case of restart.

We *do* return on iret path in case of restart, TYVM.

> So why do we lie to ptrace (and iret!) at all?  Why not just fill in
> pt_regs with the registers as they were (at least the
> non-clobbered-by-sysenter ones), set the actual C parameters correctly
> to contain the six arguments (in rdi, rsi, etc.), do the syscall, and
> return back to userspace without any funny business?  Is there some
> ABI reason that, once we've started lying to tracers, we have to keep
> doing so?

We do not lie to ptrace and iret.  At all.  We do just what you have
described.  And fuck up when restart returns us to the SYSCALL / SYSENTER
instruction again, which expects the different calling conventions,
so the values arranged in registers in the way int 0x80 would expect
do us no good.
