Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab2DCRSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:18:55 -0400
Received: from trent.utfs.org ([94.185.90.103]:33357 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab2DCRSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:18:54 -0400
Date: Tue, 3 Apr 2012 10:18:46 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 3.4.0-rc1: No init found
In-Reply-To: <1333440522.3040.9.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1204030953320.4930@trent.utfs.org>
References: <alpine.DEB.2.01.1204030008080.4930@trent.utfs.org> <1333440522.3040.9.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012 at 18:08, Benjamin Herrenschmidt wrote:
> I have observed this randomly on the G5 ... sometimes, if I try again,
> it works... it's very very odd. There is some kind of race maybe with
> async startup ? Or a problem with the vfs path walking ? It's certainly
> not easily reproducable for me, it goes away from one boot to the next.

It's 100% reproducible for me. This PowerBook G4 (1.25Ghz) is not the 
fastes though, maybe a race triggers more easily here...?

> > PS: Unfortunately I cannot boot into the old (3.3-rc7) kernel 
> >     right now (which is still installed via "yaboot" and present in
> >     /boot), because of this: 
> >     http://nerdbynature.de/bits/3.4.0-rc1/init/mac-invalid-memory.JPG
> >     Booting into Debian's "squeeze" kernel (2.6.32) which resides in
> >     the same /boot directory succeeds.
> 
> Hrm, did it used to boot ?

I'm using the "backup" kernel only when the new one has an issue, so I 
have not tested it for a while, but it used to work, for sure.

> Can you do printenv in OF and tell me what
> your load-base, real-base, virt-base etc... are ?

load-base is 0x800000, real-base and virt-base is set to "-1", please see
http://nerdbynature.de/bits/3.4.0-rc1/init/printenv-1.JPG

Not sure if this is related, but at the end of each kernel compilation, 
the following messages are printed:

------------
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  WRAP    arch/powerpc/boot/zImage.pmac
INFO: Uncompressed kernel (size 0x6e52f8) overlaps the address of the wrapper(0x400000)
INFO: Fixing the link_address of wrapper to (0x700000)
  WRAP    arch/powerpc/boot/zImage.coff
INFO: Uncompressed kernel (size 0x6e52f8) overlaps the address of the wrapper(0x500000)
INFO: Fixing the link_address of wrapper to (0x700000)
  WRAP    arch/powerpc/boot/zImage.miboot
INFO: Uncompressed kernel (size 0x6d4b80) overlaps the address of the wrapper(0x400000)
INFO: Fixing the link_address of wrapper to (0x700000)
  Building modules, stage 2.
  MODPOST 24 modules
------------

I started to see these messages in January (around Linux 3.2.0), but never 
investigated what it was since the produced kernels continued to boot just 
fine.

> Might also be worth updating yaboot, debian should have 1.3.16 nowadays.

Debian/stable still has 1.3.13a, I'll try to install 1.3.16 from 
Debian/testing.

Thanks for your help,
Christian.
-- 
BOFH excuse #217:

The MGs ran out of gas.
