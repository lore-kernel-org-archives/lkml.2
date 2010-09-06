Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab0IFOQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:16:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60694 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0IFOQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:16:13 -0400
Date: Mon, 6 Sep 2010 16:16:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 4/15]  4: uprobes: x86 specific
 functions for user space breakpointing.
Message-ID: <20100906161607.35740b74@basil.nowhere.org>
In-Reply-To: <20100906134407.GF14891@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	<20100825134210.5447.10126.sendpatchset@localhost6.localdomain6>
	<87pqwvm8cl.fsf@basil.nowhere.org>
	<20100903174832.GB14891@linux.vnet.ibm.com>
	<20100906095319.7c2fa9b0@basil.nowhere.org>
	<20100906134407.GF14891@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 19:14:07 +0530
Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> [adding Masami and Jim to the copy list] 
> 
> > > I havent tried any fuzz tests with the instruction decoder. But I
> > > am not sure if Masami has tried that out some of these. 
> > > One question: Do you want to test uprobes with crashme or test
> > > instruction decoder with crashme.
> > 
> > Ideally both, but as a minimum the part that is exposed
> > to user space, that is uprobes.
> 
> Okay, I will test uprobes with crashme.

crashme and valid 1/2 bit corrupted code please if possible. I'm 
not sure crashme alone has enough coverage.


> > > 
> > > Did you get a chance to look at
> > > validate_insn_32bit/validate_insn_64bits? If you feel that
> > > validate_insn_32bit/validate_insn_64bits? are unable to detect
> > > valid codes, then I will certainly rework.
> > 
> > I don't think you can do a 100% solution because for 100%
> > you would need to know the code segment the CPU is going
> > to use later, and that's not possible in advance.
> > 
> 
> I think you are referring to RIP related instructions, this how we
> handle them. 

I just meant regarding long mode vs compat mode which defines
whether REX prefixes are valid or not. Because this can
change any time (if the application does a long jump) you
cannot know in advance what it is going to use. But 
it's also very rare to use long jumps at all, so this
can be probably ignored (but should be documented somewhere),
and just guess based on the executable. I just wanted
to point out that it's not a 100% solution.

I don't think you need to care about segment bases either. While
they can be used (16bit Wine or dosemu) it's quite rare
and not supporting uprobes for this is totally reasonable.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
