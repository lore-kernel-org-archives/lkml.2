Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab0FCJaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:30:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40865 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab0FCJaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:30:03 -0400
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/5] kdump: extract log buffer and registers from	vmcore on NMI button pressing
From: Andi Kleen <andi@firstfloor.org>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
	<20100602151611.GA3174@redhat.com> <87iq60a3rh.wl%vmayatsk@redhat.com>
Date: Thu, 03 Jun 2010 11:30:01 +0200
In-Reply-To: <87iq60a3rh.wl%vmayatsk@redhat.com> (Vitaly Mayatskikh's message of "Thu\, 03 Jun 2010 11\:01\:38 +0200")
Message-ID: <87d3w8xy3q.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:
>
> Obviously, this change doesn't help if 2nd kernel is not able to
> boot. But there are other problems, which may prevent vmcore to be
> captured. For example, machine has RAM > HDD and it may save vmcore
> only over network. If network fails (e.g., due to bugs in NIC drivers
> or NFS, what is not so rare), and dump capture environment is
> non-interactive, or it doesn't have development tools like `crash',
> there's no chance even to guess what has happened.

In this case you don't need NMI, sysrq or some /sys trigger
is good enough.

NMI would be only needed if the crash kernel is completely
hosed too.

> Other possibilities of failure may include broken RAID controller,
> HDD, RAM. NMI button in such situations is a last chance to see old
> log.

The big problem is that the NMI is used by more and more subsystems,
and several of them tend to eat all NMIs, so the leftovers are less and
less.  Overall I would not consider it reliable.

Also NMI buttons are not actually all that common.

I'm also not sure you really need the analysis in kernel space.

Why not have a user space program that does a quick analysis
of the previous vmcore and dumps a summary only?  In fact 
I suspect crash can already do that.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
