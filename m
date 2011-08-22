Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1HVBTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:19:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47529 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab1HVBTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:19:53 -0400
Date: Mon, 22 Aug 2011 02:19:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        mingo@redhat.com, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
Message-ID: <20110822011939.GN2203@ZenIV.linux.org.uk>
References: <4E501F51.9060905@nod.at>
 <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
 <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
 <20110821063443.GH2203@ZenIV.linux.org.uk>
 <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
 <20110821144352.GJ2203@ZenIV.linux.org.uk>
 <20110821164124.GL2203@ZenIV.linux.org.uk>
 <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
 <CA+55aFztZ=r5wa0x26KJQxvZOaQq8s2v3u50wCyJcA-Sc4g8gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFztZ=r5wa0x26KJQxvZOaQq8s2v3u50wCyJcA-Sc4g8gQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 06:09:00PM -0700, Linus Torvalds wrote:
> On Sun, Aug 21, 2011 at 5:44 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> >
> > Which suggests an easy-ish fix: if sysenter is used or if syscall is
> > entered from the EIP is is supposed to be entered from, then just
> > change ip in the argument save to point to the int 0x80 instruction.
> 
> Indeed. Just add an "int 0x80" instruction to the vsyscall thing, and
> you'd be done.
> 
> In fact, just replace the
> 
>   jmp .Lenter_kernel
> 
> with
> 
>   int 0x80
> 
> and you'd be pretty much all done, no?

In case of sysenter - almost, in case of syscall - nope...
