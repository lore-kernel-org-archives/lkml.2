Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab1HVFEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 01:04:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53440 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1HVFEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 01:04:07 -0400
Message-ID: <4E51E325.2050502@zytor.com>
Date: Sun, 21 Aug 2011 22:03:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <luto@mit.edu>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
References: <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk> <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com> <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk> <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com> <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com> <20110822040759.GQ2203@ZenIV.linux.org.uk> <4E51D70A.1060001@zytor.com> <20110822042605.GR2203@ZenIV.linux.org.uk>
In-Reply-To: <20110822042605.GR2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2011 09:26 PM, Al Viro wrote:
> On Sun, Aug 21, 2011 at 09:11:54PM -0700, H. Peter Anvin wrote:
>>> lack of point - the *only* CPU where it would matter would be K6-2, IIRC,
>>> and (again, IIRC) it had some differences in SYSCALL semantics compared to
>>> K7 (which supports SYSENTER as well).  Bugger if I remember what those
>>> differences might've been...  Some flag not cleared?
>>
>> The most likely reason for a binary to execute a stray SYSCALL is
>> because they read it out of the vdso.  Totally daft, but we certainly
>> see a lot of stupid things as evidenced by the JIT thread earlier this
>> month.
> 
> Um...  What, blindly, no matter what surrounds it in there?  What will
> happen to the same eager JIT when it steps on SYSENTER?

The JIT will have had to manage SYSENTER already.  It's not a change,
whereas SYSCALL would be.  We could just try it, and see if anything
breaks, of course.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

