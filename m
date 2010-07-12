Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab0GLTIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:08:43 -0400
Received: from eazy.amigager.de ([213.239.192.238]:56368 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0GLTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:08:41 -0400
Date: Mon, 12 Jul 2010 21:08:37 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16207] Suspend and VT switch hangs since 2.6.34
Message-ID: <20100712190837.GA8278@mac.home>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
 <Hc02ROPrUsG.A.zdH.cq7NMB@chimera>
 <20100712092003.074ab8ee@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712092003.074ab8ee@virtuousgeek.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 09:20:03 -0700, Jesse Barnes wrote:
> On Sat, 10 Jul 2010 02:33:28 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.33 and 2.6.34.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16207
> > Subject		: Suspend and VT switch hangs since 2.6.34
> > Submitter	: Tino Keitel <tino.keitel+xorg@tikei.de>
> > Date		: 2010-06-09 17:53 (31 days old)
> > Message-ID	: <20100609175356.GA17332@x61.home>
> > References	: http://marc.info/?l=linux-kernel&m=127610606214060&w=2
> 
> Two commits in the X server repo (1.8 branch commits shown) might help
> here:
> 
> commit	665aa7ce8645b50b888db32ebab4e192dbe00649
>   OS support: fix writeable client vs IgnoreClient behavior
> 
> commit	090d26723f7cdbb3aebfe212170b7f81c163dd7b
>   dixstruct: make ignoreCount change more ABI friendly
> 
> 2.6.34 introduced some new features, and X will test for them and use
> them if available.  However, the server's handling of clients was buggy
> with the new code, which could cause clients to hang after VT switch,
> waiting to be woken up.

If if matters, I saw such messages in the server log when the hang
happened:

[mi] EQ overflowing. The server is probably stuck in an infinite loop.

Backtrace:
0: /usr/bin/X (xorg_backtrace+0x28) [0x4ac648]
1: /usr/bin/X (mieqEnqueue+0x1f4) [0x4a1db4]
2: /usr/bin/X (xf86PostMotionEventP+0xc4) [0x464594]
3: /usr/lib/xorg/modules/input/evdev_drv.so (0x7f98a6913000+0x52ef)
[0x7f98a69182ef]
4: /usr/bin/X (0x400000+0x73557) [0x473557]
5: /usr/bin/X (0x400000+0x11a3b4) [0x51a3b4]
6: /lib/libpthread.so.0 (0x7f98aab39000+0xea60) [0x7f98aab47a60]
7: /lib/libc.so.6 (memcpy+0x15b) [0x7f98a96a894b]
8: /usr/lib/xorg/modules/libfb.so (fbBlt+0xfc) [0x7f98a7227ddc]
9: /usr/lib/xorg/modules/libfb.so (fbOddTile+0x16e) [0x7f98a723427e]
10: /usr/lib/xorg/modules/libfb.so (fbFill+0x402) [0x7f98a722b982]
11: /usr/lib/xorg/modules/libfb.so (fbPolyFillRect+0x1da)
[0x7f98a722bcda]
12: /usr/lib/xorg/modules/drivers/intel_drv.so (0x7f98a7643000+0x3fbd1)
[0x7f98a7682bd1]
13: /usr/lib/xorg/modules/drivers/intel_drv.so (0x7f98a7643000+0x39450)
[0x7f98a767c450]
14: /usr/bin/X (0x400000+0xdaffb) [0x4daffb]
15: /usr/bin/X (miPaintWindow+0x1aa) [0x452cea]
16: /usr/bin/X (miWindowExposures+0xc8) [0x453088]
17: /usr/bin/X (0x400000+0x11f1e7) [0x51f1e7]
18: /usr/bin/X (miHandleValidateExposures+0x2b) [0x56892b]
19: /usr/bin/X (0x400000+0x6b0c7) [0x46b0c7]
20: /usr/bin/X (xf86EnableDisableFBAccess+0x77) [0x46b177]
21: /usr/bin/X (0x400000+0x148660) [0x548660]
22: /usr/bin/X (xf86Wakeup+0x22a) [0x47397a]
23: /usr/bin/X (WakeupHandler+0x4b) [0x42adbb]
24: /usr/bin/X (WaitForSomething+0x1d5) [0x45eb45]
25: /usr/bin/X (0x400000+0x48a62) [0x448a62]
26: /usr/bin/X (0x400000+0x25c1a) [0x425c1a]
27: /lib/libc.so.6 (__libc_start_main+0xfd) [0x7f98a964aabd]
28: /usr/bin/X (0x400000+0x257c9) [0x4257c9]

I use Xserver 1.7.x, the one which is currently in Debian unstable.

Regards,
Tino
