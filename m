Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0G0XmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:42:12 -0400
Received: from ozlabs.org ([203.10.76.45]:42203 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab0G0XmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:42:08 -0400
Date: Wed, 28 Jul 2010 09:41:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 04/11] powerpc: Simplify update_vsyscall
Message-ID: <20100727234152.GC14947@brick.ozlabs.ibm.com>
References: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-4-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-5-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279068988-21864-5-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 05:56:21PM -0700, John Stultz wrote:

> Currently powerpc's update_vsyscall calls an inline update_gtod.
> However, both are straightforward, and there are no other users,
> so this patch merges update_gtod into update_vsyscall.
> 
> Compiles, but otherwise untested.

This and the following two patches will cause interesting conflicts
with two commits in Ben Herrenschmidt's powerpc.git next branch,
specifically 8fd63a9e ("powerpc: Rework VDSO gettimeofday to prevent
time going backwards") and c1aa687d ("powerpc: Clean up obsolete code
relating to decrementer and timebase") from me.  In fact the first of
those two commits includes changes equivalent to those in your 5/11
patch ("powerpc: Cleanup xtime usage"), as far as I can see.

BTW, BenH's tree is at:

git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git

Paul.
