Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1HUOvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:51:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34778 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab1HUOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:51:52 -0400
Date: Sun, 21 Aug 2011 15:51:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
Message-ID: <20110821145126.GK2203@ZenIV.linux.org.uk>
References: <20110820011845.GC2203@ZenIV.linux.org.uk>
 <4E4FD12F.70508@nod.at>
 <20110820201406.GF2203@ZenIV.linux.org.uk>
 <4E501F51.9060905@nod.at>
 <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
 <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
 <20110821063443.GH2203@ZenIV.linux.org.uk>
 <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
 <CAObL_7HGJqP-hdXpdRLYkksfeVtQ1z1ngP58gdTnWwD57duaXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7HGJqP-hdXpdRLYkksfeVtQ1z1ngP58gdTnWwD57duaXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 09:37:18AM -0400, Andrew Lutomirski wrote:

> Gack.  Is this a holdover from the 32-bit code that shares the
> argument save area with the parameters passed on the C stack?  If so,
> we could just set up the argument save area honestly and pass the real
> parameters in registers like 64-bit C code expects.
> 
> If the tracing and restart cases use iret to return to userspace, this
> should all just work.  ptrace users shouldn't notice the overhead, and
> syscall restart is presumably slow enough anyway that it wouldn't
> matter.  The userspace entry code would be as simple as:
> 
> sysenter
> ret
> 
> or
> 
> sysexit
> ret

You are making no sense at all...
