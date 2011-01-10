Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1AJXuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:50:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43056 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1AJXur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:50:47 -0500
Date: Mon, 10 Jan 2011 15:49:59 -0800
From: Kees Cook <kees.cook@canonical.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Ingo Molnar <mingo@elte.hu>, Xiaotian Feng <xtfeng@gmail.com>,
        Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Message-ID: <20110110234959.GE4979@outflux.net>
References: <4CE2F914.9070106@free.fr>
 <24422.1290656467@localhost>
 <20101126182355.62615dff@mat-laptop>
 <20101208221951.GO5750@outflux.net>
 <20101211001857.4c5e0794@mat-laptop>
 <20101222124019.GG10809@elte.hu>
 <34428.1293053719@localhost>
 <AANLkTin55DXcQnK3NY7y-v8TXj5w-XT2rTJo9p90tj4g@mail.gmail.com>
 <20110107130426.GA24259@elte.hu>
 <20110108122455.38d31524@mat-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110108122455.38d31524@mat-laptop>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
