Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab2BHLwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:52:55 -0500
Received: from bar.sig21.net ([80.81.252.164]:50211 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab2BHLwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:52:53 -0500
Date: Wed, 8 Feb 2012 12:52:44 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org
Subject: Re: swap storm since kernel 3.2.x
Message-ID: <20120208115244.GA24959@sig21.net>
References: <201202041109.53003.toralf.foerster@gmx.de>
 <201202051107.26634.toralf.foerster@gmx.de>
 <CAJd=RBCvvVgWqfSkoEaWVG=2mwKhyXarDOthHt9uwOb2fuDE9g@mail.gmail.com>
 <201202080956.18727.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201202080956.18727.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 09:56:15AM +0100, Toralf Förster wrote:
> 
> From what I can tell is this:
> If the system is under heavy I/O load and hasn't too much free RAM (git pull, 
> svn update and RAM consuming BOINC applications) then kernel 3.0.20 handle 
> this somehow while 3.2.x run into a swap storm like.

FWIW, I also saw heavy swapping with 3.2.2 with the
CONFIG_DEBUG_OBJECTS issue reported here:
http://lkml.org/lkml/2012/1/30/227

But the thing is that even though SUnreclaim was
huge there was still 1G MemFree and it swapped heavily
on idle system when just switching between e.g. Firefox and gvim.

Today I'm running 3.2.4 with CONFIG_DEBUG_OBJECTS disabled
(but otherwise the same config) and it doesn't swap even
after a fair amount of I/O:

MemTotal:        3940088 kB
MemFree:         1024920 kB
Buffers:          293328 kB
Cached:           447796 kB
SwapCached:           24 kB
Active:           847136 kB
Inactive:         567200 kB
Active(anon):     478736 kB
Inactive(anon):   246744 kB
Active(file):     368400 kB
Inactive(file):   320456 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       3903484 kB
SwapFree:        3903196 kB
Dirty:                16 kB
Writeback:             0 kB
AnonPages:        673192 kB
Mapped:            40956 kB
Shmem:             52268 kB
Slab:            1434188 kB
SReclaimable:    1367388 kB
SUnreclaim:        66800 kB
KernelStack:        1600 kB
PageTables:         4880 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     5873528 kB
Committed_AS:    1744916 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      348116 kB
VmallocChunk:   34359362739 kB
DirectMap4k:       12288 kB
DirectMap2M:     4098048 kB

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
  586182 353006  60%    1.74K  32595       18   1043040K ext3_inode_cache
  289062 170979  59%    0.58K  10706       27    171296K dentry
  247266 107729  43%    0.42K  13737       18    109896K buffer_head


Johannes
