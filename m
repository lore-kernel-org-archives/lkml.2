Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685Ab0HFSKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:10:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45177 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0HFSJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:09:58 -0400
Message-ID: <4C5C4E7A.8040603@kernel.org>
Date: Fri, 06 Aug 2010 11:03:38 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, stable@kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>,
        Brian Gerst <brgerst@gmail.com>, Glauber Costa <glommer@redhat.com>,
        Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Jeff Dike <jdike@addtoit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Palfrader <peter@palfrader.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [GIT PULL] x86/asm for 2.6.36
References: <201008052037.o75KbxSS022005@hera.kernel.org> <AANLkTimZF5U-AmD6200gnTuNzX5nUqVqEo_NmiH3rz5n@mail.gmail.com> <4C5C4A23.6070006@zytor.com>
In-Reply-To: <4C5C4A23.6070006@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 10:45 AM, H. Peter Anvin wrote:
> 
> It's worth noting that in this particular case the code itself looks
> like this:
> 
> 	set_64bit((unsigned long *)&irte->low, irte_modified->low);
> 	set_64bit((unsigned long *)&irte->high, irte_modified->high);
> 
> ... where the existing cast is there because irte->low and irte->high
> are types __u64.  In other words, with the "more logical" u64 prototype
> the casts should just get removed.
> 

Looking through the build I'm currently running, so far, it is smoking
out a bunch of unnecessary casts and wrappers, for example, in kvm/mmu.c:

static void __set_spte(u64 *sptep, u64 spte)
{
#ifdef CONFIG_X86_64
	set_64bit((unsigned long *)sptep, spte);
#else
	set_64bit((unsigned long long *)sptep, spte);
#endif
}

... which just becomes the much cleaner ...

static void __set_spte(u64 *sptep, u64 spte)
{
	set_64bit(sptep, spte);
}

I'll go through all these as this build finishes and give you an updated
tree to pull, ok?

	-hpa
