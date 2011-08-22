Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1HVBtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:49:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45761 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab1HVBtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:49:03 -0400
Message-ID: <4E51B56F.3080301@zytor.com>
Date: Sun, 21 Aug 2011 18:48:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Andrew Lutomirski <luto@mit.edu>,
        mingo@redhat.com, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
References: <20110820201406.GF2203@ZenIV.linux.org.uk> <4E501F51.9060905@nod.at> <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com> <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com> <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk> <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com> <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk> <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com> <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
In-Reply-To: <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2011 06:41 PM, Linus Torvalds wrote:
> If people are using syscall directly, we're pretty much stuck. No
> amount of "that's hopelessly wrong" will ever matter. We don't break
> existing binaries.
> 
> That said, I'd *hope* that everybody uses the vdso32, simply because
> user programs are not supposed to know which CPU they are running on
> and if that CPU even *supports* the syscall instruction. In which case
> it may be possible that we can play games with the vdso thing. But
> that really would be conditional on "nobody ever reports a failure".

I think we found that out with the vsyscall emulation issue last cycle.
 It works, so it will have been used, somewhere...

> But if that's possible, maybe we can increment the RIP by 2 for
> 'syscall', and slip an "'int 0x80" after the syscall instruction in
> the vdso there? Resulting in the same pseudo-solution I suggested for
> sysenter...

I think we have the above problem.

The problem here is that the syscall state is actually more complex than
we retain: the entire state is given by (entry point, register state);
with that amount of state we have all the information needed to *either*
extract the syscall arguments *or* the register contents.  Without
those, we can only represent one of the two possible metalevels (right
now we represent the higher-level metalevel, the argument vector), but
we need both for different usages.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

