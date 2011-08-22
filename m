Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab1HVJ4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:56:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:33172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab1HVJz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:55:57 -0400
Date: Mon, 22 Aug 2011 11:53:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Borislav Petkov <bp@amd64.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110822095336.GB25949@kernel.org>
References: <20110821144352.GJ2203@ZenIV.linux.org.uk>
 <20110821164124.GL2203@ZenIV.linux.org.uk>
 <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
 <20110822011645.GM2203@ZenIV.linux.org.uk>
 <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
 <4E51B56F.3080301@zytor.com>
 <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com>
 <20110822020737.GP2203@ZenIV.linux.org.uk>
 <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com>
 <4E51D597.3060800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E51D597.3060800@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Mon, 22 Aug 2011 09:54:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Borislav,
> 
> We're tracking down an issue with the way system call arguments are 
> handled on 32 bits.  We have a solution for SYSENTER but not 
> SYSCALL; fixing SYSCALL "properly" appears to be very difficult at 
> best.
> 
> So the question is: how much overhead would it be to simply fall 
> back to int $0x80 or some other legacy-style domain crossing 
> instruction for 32-bit system calls on AMD64 processors?  We don't 
> ever use SYSCALL in legacy mode, so native i386 kernels are 
> unaffected.

Last i measured INT80 and SYSCALL costs they were pretty close to 
each other on AMD CPUs - closer than on Intel.

Also, most installations are either pure 32-bit or dominantly 64-bit, 
the significantly mixed-mode case is dwindling.

Unifying some more in this area would definitely simplify things ...

Thanks,

	Ingo
