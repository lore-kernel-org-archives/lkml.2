Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2LBMoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 07:44:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34126 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751467Ab2LBMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 07:44:09 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1/L5wNkbdDL63jyfCWw05qwiNpBUr86NaU0CmSa9/
	/4bxy1ap9AMdRs
Message-ID: <1354452243.22969.48.camel@soupermouf>
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
From: Dimitrios Apostolou <jimis@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, "Theodore Ts'o" <tytso@mit.edu>
Date: Sun, 02 Dec 2012 14:44:03 +0200
In-Reply-To: <1353855815.22969.20.camel@soupermouf>
References: <1353855815.22969.20.camel@soupermouf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, the problem in the quoted message still happens, shouldn't all of
ext4_inode_cache slab be emptied after "echo 3
> /proc/sys/vm/drop_caches"? In my case slab uses too much memory even
after all processes finish and system is in bad shape due to lack of
physical RAM. CC'ing tytso and Catalin Marinas since I've not been able
to track any leak with kmemleak.

Kernel is booted with slub_debug=,ext4_inode_cache, as this is the only
way to avoid for some time the following message. Nevertheless it has
not been able to show any leak.

kmemleak: Cannot allocate a kmemleak_object structure
kmemleak: Automatic memory scanning thread ended
kmemleak: Kernel memory leak detector disabled

Please have a look at the log (archived at [1]).

[1] http://lkml.indiana.edu/hypermail/linux/kernel/1211.3/00183.html


Thanks,
Dimitris


On Sun, 2012-11-25 at 17:03 +0200, Dimitrios Apostolou wrote:
> Hello list,
> 
> on an old PIII-500MHz laptop, 128MB RAM, kernel 3.6.6, I started a
> backup process (tar|xz -4, nice'd and ionice'd -c3) from ext4 on local
> ATA disk to ext3 on external USB disk (USB-2.0 port on PCMCIA card).
> Even though earlier system load was minimal, free memory was plenty, the
> system now is unresponsive and is thrashing the disk, but the swapfile
> is rarely touched.
> 
> I managed to get some information by renicing a root console to -20, but
> even then each keypress showed with a minimum 10s delay! In the attached
> file you can see the dmesg output, SysRq+{W,T}, ps, vmstat, slabs,
> meminfo.
> 
> I think I'm seeing paging of executable pages because ext4_inode_cache
> is aggressively using all memory, evicting other pages. However under no
> condition should realtime processes be unresponsive. What do you think?
> Please note that I've set vm.swappiness to 0 and gradually increased
> vm.vfs_cache_pressure to 1000000, but see no difference.
> 
> 
> Thanks in advance,
> Dimitris
> 
> 
> P.S. Please CC me in all replies
> 
> 


