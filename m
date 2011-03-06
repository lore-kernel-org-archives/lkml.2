Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1CFCZC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 21:25:02 -0500
Received: from trent.utfs.org ([194.246.123.103]:58704 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1CFCZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 21:25:01 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Mar 2011 21:25:00 EST
Date: Sat, 5 Mar 2011 18:16:58 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: heiko.carstens@de.ibm.com, arjan@infradead.org
Subject: arch/x86/include/asm/uaccess_32.h:212: copy_from_user() buffer size
 is not provably correct
Message-ID: <alpine.DEB.2.01.1103051749500.23816@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while trying to compile 2.6.38-rc7 with randconfigs, I noticed 
compilation would sometimes fail with:

-------------------------------------------------------
In file included from 
/usr/local/src/linux-2.6-git/arch/x86/include/asm/uaccess.h:571,                 
from /usr/local/src/linux-2.6-git/include/net/checksum.h:25,
                 from 
/usr/local/src/linux-2.6-git/include/linux/skbuff.h:28,
                 from 
/usr/local/src/linux-2.6-git/include/linux/if_ether.h:126,
                 from 
/usr/local/src/linux-2.6-git/include/linux/netdevice.h:29,
                 from 
/usr/local/src/linux-2.6-git/net/packet/af_packet.c:58:
In function 'copy_from_user',
    inlined from 'packet_getsockopt' at 
/usr/local/src/linux-2.6-git/net/packet/af_packet.c:2137:
/usr/local/src/linux-2.6-git/arch/x86/include/asm/uaccess_32.h:212: error: 
call to 'copy_from_user_overflow' declared with attribute error: 
copy_from_user() buffer size is not provably correct
-------------------------------------------------------

A few failed configs (and compile logs) are here:

  http://nerdbynature.de/bits/2.6.38-rc7/copy_from_user/

I've seen a thread[0] in Jan 2010, dealing with copy_from_user, but don't 
know if that is the reason for these compile failures.

It's not really an issue for me, since they're randconfigs anyway so might 
not even be runnable on real hardware, but thought it would be worth to 
mention anyway.

Thanks,
Christian.

[0] http://lkml.org/lkml/2010/1/5/75
-- 
BOFH excuse #395:

Redundant ACLs.
