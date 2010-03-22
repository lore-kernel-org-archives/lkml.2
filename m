Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0CVWyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:54:22 -0400
Received: from www.tglx.de ([62.245.132.106]:58075 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0CVWyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:54:21 -0400
Date: Mon, 22 Mar 2010 23:53:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
In-Reply-To: <4BA7EE72.7000507@kernel.org>
Message-ID: <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain>
References: <4BA6EA62.1030603@kernel.org> <20100321.210023.209981130.davem@davemloft.net> <4BA6F1F6.3070102@kernel.org> <20100321.213350.176660494.davem@davemloft.net> <20100322092809.GA20607@elte.hu> <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain>
 <20100322193720.GA2844@elte.hu> <4BA7CE1B.9070109@kernel.org> <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain> <4BA7EE72.7000507@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010, Yinghai Lu wrote:
> On 03/22/2010 03:09 PM, Thomas Gleixner wrote:
> > On Mon, 22 Mar 2010, Yinghai Lu wrote:
> >> On 03/22/2010 12:37 PM, Ingo Molnar wrote:
>
> >> 1. need to keep e820
> > 
> >   That's neither an argument for using lmb nor an argument not to use
> >   lmb. e820 is x86 specific BIOS wreckage and it's whole purpose is
> >   just to feed information into a (hopefully) generic early resource
> >   management facility.
> > 
> >   e820 _CANNOT_ be generalized. Period.

  I still want to know, what "need to keep e820" means for you.
 
> >> 2. use e820 range with RAM to fill lmb.memory when finizing_e820
> > 
> >   What's finizing_e820 ???
>  finish_e820_parsing();

 Yinghai, come on. Are you really expecting that everyone involved in
 this discussion goes to look up what the heck finish_e820_parsing()
 is doing ?

 You want to explain why your solution is better or why lmb is not
 sufficient, so you better go and explain what finish_e820_parsing()
 is, why finish_e820_parsing() is important and why lmb cannot cope
 with it.

> >> 3. use lmb.reserved to replace early_res.
> > 
> >   What's the implication of doing that ?
>
> early_res array is only corresponding to lmb.reserved, aka reserved
> region from kernel.
 
 Is it only corresponding (somehow) or is it a full equivivalent ?

> >> current lmb is merging the region, we can not use name tag any more.
> > 
> >   What's wrong with merging of regions ? Are you arguing about a
> >   specific region ("the region") ?

 Care to answer my question ?
 
> > 
> >   Which name tag ? And why is that name tag important ?
> 
> struct early_res {
>         u64 start, end;
>         char name[15];
>         char overlap_ok;
> };

 I'm starting to get annoyed, really. What is that name field for and
 why is that "name" field important ?

> >  
> >> may need to dump early_memtest, and use early_res for bootmem at
> >> first.
> > 
> >   Why exactly might early_memtest not longer be possible ?
>
> early_memtest need to call find_e820_area_size
> current lmb doesn't have that kind of find util.
> the one memory subtract reserved memory by kernel.

 What subtracts what ? And why is it that hard to fix that ?

> > 
> >   What means "early_res for bootmem" ?
> 
> use early_res to replace bootmem, the CONFIG_NO_BOOTMEM.
> that need early_res can be double or increase the slots automatically.

 -ENOPARSE

Yinghai, I asked you to take your time and explain things in detail
instead of shooting unparseable answers within a minute.

Everyone else in this discussion tries to be as explanatory as
possible, just you expect that everyone else is going to dig out the
crystal ball to understand the deeper meanings of your patches.

Again, please take your time to explain what needs to be done or what
is impossible to solve in your opinion, so we can get that resolved in
a way which is satisfactory and useful for all parties involved.

Thanks,

	tglx
