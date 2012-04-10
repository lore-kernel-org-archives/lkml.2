Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2DJFrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:47:32 -0400
Received: from trent.utfs.org ([94.185.90.103]:39764 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab2DJFrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:47:31 -0400
Date: Mon, 9 Apr 2012 22:47:27 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.0-rc1: No init found
In-Reply-To: <1333440522.3040.9.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1204092242160.3375@trent.utfs.org>
References: <alpine.DEB.2.01.1204030008080.4930@trent.utfs.org> <1333440522.3040.9.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012 at 18:08, Benjamin Herrenschmidt wrote:
> On Tue, 2012-04-03 at 00:20 -0700, Christian Kujau wrote:
> > Going from 3.3-rc7 to 3.4-rc1 (with "make oldconfig" inbetween) did not 
> > go well on this PowerBook G4 machine:
> > 
> > Apr  2 15:18:23 [   8.318816] EXT4-fs (hda6): mounted filesystem with ordered data mode. Opts: (null)
> > Apr  2 15:18:23 [   8.320286] VFS: Mounted root (ext4 filesystem) readonly on device 3:6.
> > Apr  2 15:18:23 [   8.341555] devtmpfs: mounted
> > Apr  2 15:18:23 [   8.343384] Freeing unused kernel memory: 204k freed
> > Apr  2 15:18:23 [   8.457056] Kernel panic - not syncing: No init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.
> > Apr  2 15:18:23 [   8.459936] Rebooting in 180 seconds..
> 
> I have observed this randomly on the G5 ... sometimes, if I try again,
> it works... it's very very odd. There is some kind of race maybe with
> async startup ? Or a problem with the vfs path walking ? It's certainly
> not easily reproducable for me, it goes away from one boot to the next.

I tried to sit this one out, but when -rc2 did not magicially fix it I 
started a git bisect, this is what I got:

* a546498f3bf9aac311c66f965186373aee2ca0b0 is the first bad commit

commit a546498f3bf9aac311c66f965186373aee2ca0b0
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Wed Mar 7 16:48:45 2012 +1100

    powerpc: Call do_page_fault() with interrupts off


Full bisect-log & more: http://nerdbynature.de/bits/3.4.0-rc1/init/ 

Thanks,
Christian.
-- 
BOFH excuse #124:

user to computer ration too low.
