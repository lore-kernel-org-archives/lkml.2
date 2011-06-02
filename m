Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab1FBAQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 20:16:30 -0400
Received: from trent.utfs.org ([194.246.123.103]:38758 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab1FBAQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 20:16:27 -0400
Date: Wed, 1 Jun 2011 17:16:23 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux ppc dev <linuxppc-dev@lists.ozlabs.org>, zajec5@gmail.com,
        linville@tuxdriver.com, benh@kernel.crashing.org
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
In-Reply-To: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1106011712270.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011 at 16:50, Christian Kujau wrote:
> trying to boot 3.0-rc1 on powerpc32 only progresses until:
> 
>   > Kernel virtual memory layout:
>   >   * 0xfffcf000..0xfffff000  : fixmap

After hours (and hours!) of git-bisecting, it said:

-----------------------
ccc7c28af205888798b51b6cbc0b557ac1170a49 is the first bad commit
commit ccc7c28af205888798b51b6cbc0b557ac1170a49
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Fri Apr 1 13:26:52 2011 +0200

    ssb: pci: implement serdes workaround
    
    Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>
-----------------------

When I reverted this one from the gi-bisected tree, the box continued to 
boot (until it got stuck again during IDE/CDROM init, but that may be a 
different story). I'l; try to revert this from a vanilla 3.0-rc1 and see 
if it helps

Thanks,
Christian.

Full gist-bisect-log: http://nerdbynature.de/bits/3.0-rc1/

> And then the system hangs, does not respond to keyboard (sysrq does not 
> seem to work on this PowerBook G4). But after a while the system reboots 
> itself, so I guess the machine panicked but did not print anything on the 
> screen.
> 
> Full messages (picture), config & (working) dmesg:
> 
>    http://nerdbynature.de/bits/3.0-rc1/
> 
-- 
BOFH excuse #406:

Bad cafeteria food landed all the sysadmins in the hospital.
