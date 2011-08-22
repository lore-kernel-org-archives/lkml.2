Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab1HVBUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:20:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44214 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab1HVBUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:20:08 -0400
Message-ID: <4E51AEAD.8040005@zytor.com>
Date: Sun, 21 Aug 2011 18:19:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Lutomirski <luto@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        mingo@redhat.com, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
References: <20110820011845.GC2203@ZenIV.linux.org.uk> <4E4FD12F.70508@nod.at> <20110820201406.GF2203@ZenIV.linux.org.uk> <4E501F51.9060905@nod.at> <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com> <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com> <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk> <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com> <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk> <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com> <CA+55aFztZ=r5wa0x26KJQxvZOaQq8s2v3u50wCyJcA-Sc4g8gQ@mail.gmail.com>
In-Reply-To: <CA+55aFztZ=r5wa0x26KJQxvZOaQq8s2v3u50wCyJcA-Sc4g8gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2011 06:09 PM, Linus Torvalds wrote:
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
> 
> (Ok, that's probably a huge over-simplification, but perhaps "close
> enough" to true that it would be workable)
> 

Hm... I think a jump to something which adjusts %esp and invokes int
$0x80 might just work, but only for SYSENTER.

SYSCALL is different, especially since SYSCALL is legal to execute from
anywhere in userspace (and no, as we have learned already doing EIP
checking is *NOT* acceptable.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

