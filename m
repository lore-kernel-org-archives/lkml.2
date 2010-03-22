Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab0CVWKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:10:20 -0400
Received: from www.tglx.de ([62.245.132.106]:59508 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab0CVWKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:10:18 -0400
Date: Mon, 22 Mar 2010 23:09:26 +0100 (CET)
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
In-Reply-To: <4BA7CE1B.9070109@kernel.org>
Message-ID: <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>
References: <4BA6EA62.1030603@kernel.org> <20100321.210023.209981130.davem@davemloft.net> <4BA6F1F6.3070102@kernel.org> <20100321.213350.176660494.davem@davemloft.net> <20100322092809.GA20607@elte.hu> <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain>
 <20100322193720.GA2844@elte.hu> <4BA7CE1B.9070109@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai,

On Mon, 22 Mar 2010, Yinghai Lu wrote:
> On 03/22/2010 12:37 PM, Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
>
> >> The main point is that there is still no answer why lmb cannot be used and 
> >> the reposted patch still is a full move of the x86 e820 functions into 
> >> kernel/fw_memmap.c.
> >>
> >> That's not a generalization, that's simply a relocation of x86 code to 
> >> kernel/. And I agree with Dave and Ben that this is an useless exercise.
> > 
> > ok - i think you are right. Yinghai, mind having a look at using
> > lib/lmb.c for all this?
> 
> 1. need to keep e820

  That's neither an argument for using lmb nor an argument not to use
  lmb. e820 is x86 specific BIOS wreckage and it's whole purpose is
  just to feed information into a (hopefully) generic early resource
  management facility.

  e820 _CANNOT_ be generalized. Period.

> 2. use e820 range with RAM to fill lmb.memory when finizing_e820

  What's finizing_e820 ???

> 3. use lmb.reserved to replace early_res.

  What's the implication of doing that ?
 
> current lmb is merging the region, we can not use name tag any more.

  What's wrong with merging of regions ? Are you arguing about a
  specific region ("the region") ?

  Which name tag ? And why is that name tag important ?
 
> may need to dump early_memtest, and use early_res for bootmem at
> first.

  Why exactly might early_memtest not longer be possible ?

  What means "early_res for bootmem" ?

Please take some time to explain in detail. Throwing one liners and
buzzwords w/o context into such a discussion is more than counter
productive.

Thanks,

	tglx
