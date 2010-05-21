Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab0EUD0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 23:26:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47742 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab0EUD0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 23:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oWMiw4uSBAIKlBhzSdn+dH39Xy34oX0Mjrz58lFN6zK0nuaf/VsS5t1nxVqFdIPonW
         rTqlOgMkrLEvPH/etE4zjsh2QGTUb8oCs3JFBrWCLUh7UILRWOBYLSoDRpucBnYMlCUY
         f5NZR/MgxsgLUXpNCbWTrXh9L6zhwwmhkmIs4=
Subject: Re: Transparent Hugepage Support #25
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       Izik Eidus <ieidus@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <20100521000539.GA5733@random.random>
References: <20100521000539.GA5733@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 05:26:13 +0200
Message-ID: <1274412373.4977.8.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 21 mai 2010 à 02:05 +0200, Andrea Arcangeli a écrit :
> If you're running scientific applications, JVM or large gcc builds
> (see attached patch for gcc), and you want to run from 2.5% faster for
> kernel build (on bare metal), or 8% faster in translate.o of qemu (on
> bare metal), 15% faster or more with virt and Intel EPT/ AMD NPT
> (depending on the workload), you should apply and run the transparent
> hugepage support on your systems.
> 
> Awesome results have already been posted on lkml, if you test and
> benchmark it, please provide any positive/negative real-life result on
> lkml (or privately to me if you prefer). The more testing the better.
> 

Interesting !

Did you tried to change alloc_large_system_hash() to use hugepages for
very large allocations ? We currently use vmalloc() on NUMA machines...

Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)


0xffffc90000003000-0xffffc90001004000 16781312 alloc_large_system_hash+0x1d8/0x280 pages=4096 vmalloc vpages N0=2048 N1=2048
0xffffc9000100f000-0xffffc90001810000 8392704 alloc_large_system_hash+0x1d8/0x280 pages=2048 vmalloc vpages N0=1024 N1=1024
0xffffc90005882000-0xffffc90005c83000 4198400 alloc_large_system_hash+0x1d8/0x280 pages=1024 vmalloc vpages N0=512 N1=512
0xffffc90005c84000-0xffffc90006485000 8392704 alloc_large_system_hash+0x1d8/0x280 pages=2048 vmalloc vpages N0=1024 N1=1024



