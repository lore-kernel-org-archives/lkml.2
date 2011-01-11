Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1AKXcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:32:31 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59426 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab1AKXc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:32:29 -0500
Date: Tue, 11 Jan 2011 15:31:35 -0800
From: Kees Cook <kees.cook@canonical.com>
To: mingo@redhat.com, hpa@zytor.com, sliakh.lkml@gmail.com, jmorris@namei.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, ak@muc.de, davej@redhat.com,
        jiang@cs.ncsu.edu, arjan@infradead.org, castet.matthieu@free.fr,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu,
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [tip:x86/security] x86: Add NX protection for kernel data
Message-ID: <20110111233135.GL4979@outflux.net>
References: <4CE2F82E.60601@free.fr>
 <tip-5bd5a452662bc37c54fb6828db1a3faf87e6511c@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5bd5a452662bc37c54fb6828db1a3faf87e6511c@git.kernel.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:08:22PM +0000, tip-bot for Matthieu Castet wrote:
> Commit-ID:  5bd5a452662bc37c54fb6828db1a3faf87e6511c
> Gitweb:     http://git.kernel.org/tip/5bd5a452662bc37c54fb6828db1a3faf87e6511c
> Author:     Matthieu Castet <castet.matthieu@free.fr>
> AuthorDate: Tue, 16 Nov 2010 22:31:26 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 18 Nov 2010 12:52:04 +0100
> 
> x86: Add NX protection for kernel data

[I'd sent this in reply to the wrong patch before, resending now...]

Hi,

I was just shown this[1] on Xen from an Ubuntu bug report[2].

[    1.230382] NX-protecting the kernel data: 3884k
[    1.231002] BUG: unable to handle kernel paging request at c1782ae0
...
[    1.231145] Call Trace:
[    1.231152]  [<c0138481>] ? __change_page_attr+0x2c1/0x370
[    1.231161]  [<c02163a1>] ? __purge_vmap_area_lazy+0xc1/0x180
[    1.231169]  [<c013857c>] ? __change_page_attr_set_clr+0x4c/0xb0
[    1.231176]  [<c0138838>] ? change_page_attr_set_clr+0x128/0x300
[    1.231183]  [<c010798e>] ? __raw_callee_save_xen_restore_fl+0x6/0x8
[    1.231192]  [<c0159ca1>] ? vprintk+0x171/0x3f0
[    1.231198]  [<c0138bdf>] ? set_memory_nx+0x5f/0x70


Does Xen have different size page table allocations or something weird?

-Kees

[1] http://launchpadlibrarian.net/61853131/natty-failed-boot-ec2.txt
[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/699828

-- 
Kees Cook
Ubuntu Security Team
