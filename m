Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab0KGSCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:02:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55672 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0KGSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:02:08 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Marcus Meissner <meissner@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, fweisbec@gmail.com, tj@kernel.org,
        mort@sgi.com, akpm@osdl.org, security@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu>
	<20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu>
	<20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de>
Date: Sun, 07 Nov 2010 19:02:02 +0100
In-Reply-To: <20101104143322.GL25118@suse.de> (Marcus Meissner's message of
	"Thu, 4 Nov 2010 15:33:22 +0100")
Message-ID: <871v6xt3l1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Meissner <meissner@suse.de> writes:
>
> I also briefly thought about kernel ASLR, but my knowledge of the kernel
> loading is too limited whether this is even possible or at all useful.

Kernel ASLR sounds like a good idea, although there are some traps.

On 32bit the available range is not too great, only a few hundred MB
max. Probably less on a larger systems, there will conflicts with a
large mem_map.  On 64bit x86 it's nearly 2GB and somewhat easier
(although a large mem_map may still be a problem)

You still want to not stray too much from a 2MB alignment
to make sure most of the main kernel is handled by a single 2MB TLB
entry. 

It would not be too hard to do today using kexec and loading the kernel
twice.  Right now the kexec command doesn't allow specifying
the address, but the kernel interface supports it, so it could
be just implemented in the user tool.

Doing it with a single boot sequence would be a bit more work.
Right now the relocation entries are not put into the bzImage
and that would be needed.

That would not cover modules, but it shouldn't be too difficult
to do it for those either.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
