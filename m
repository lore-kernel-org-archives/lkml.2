Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1HVBlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:41:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756504Ab1HVBlj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:41:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110822011645.GM2203@ZenIV.linux.org.uk>
References: <20110820201406.GF2203@ZenIV.linux.org.uk> <4E501F51.9060905@nod.at>
 <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
 <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
 <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
 <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk>
 <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com> <20110822011645.GM2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Aug 2011 18:41:16 -0700
Message-ID: <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        mingo@redhat.com, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 6:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Is that ability a part of userland ABI or are we declaring that hopelessly
> wrong and require to go through the function in vdso32?  Linus?

If people are using syscall directly, we're pretty much stuck. No
amount of "that's hopelessly wrong" will ever matter. We don't break
existing binaries.

That said, I'd *hope* that everybody uses the vdso32, simply because
user programs are not supposed to know which CPU they are running on
and if that CPU even *supports* the syscall instruction. In which case
it may be possible that we can play games with the vdso thing. But
that really would be conditional on "nobody ever reports a failure".

But if that's possible, maybe we can increment the RIP by 2 for
'syscall', and slip an "'int 0x80" after the syscall instruction in
the vdso there? Resulting in the same pseudo-solution I suggested for
sysenter...

                          Linus
