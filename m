Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1ARO3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 09:29:55 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54712 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1ARO3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:29:54 -0500
Message-ID: <4D35A3D6.4070801@monstr.eu>
Date: Tue, 18 Jan 2011 15:29:42 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
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
Subject: Re: [PATCH 13 of 66] export maybe_mkwrite
References: <patchbomb.1288798055@v2.random> <15324c9c30081da3a740.1288798068@v2.random> <4D344EAF.1080401@petalogix.com> <20110117143345.GQ9506@random.random>
In-Reply-To: <20110117143345.GQ9506@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> Hi Michal,
> 
> On Mon, Jan 17, 2011 at 03:14:07PM +0100, Michal Simek wrote:
>> Andrea Arcangeli wrote:
>>> From: Andrea Arcangeli <aarcange@redhat.com>
>>>
>>> huge_memory.c needs it too when it fallbacks in copying hugepages into regular
>>> fragmented pages if hugepage allocation fails during COW.
>>>
>>> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
>>> Acked-by: Rik van Riel <riel@redhat.com>
>>> Acked-by: Mel Gorman <mel@csn.ul.ie>
>> It wasn't good idea to do it. mm/memory.c is used only for system with 
>> MMU. System without MMU are broken.
>>
>> Not sure what the right fix is but anyway I think use one ifdef make 
>> sense (git patch in attachment).
> 
> Can you show the build failure with CONFIG_MMU=n so I can understand
> better? Other places in mm.h depends on pte_t/vm_area_struct/VM_WRITE
> to be defined, if a system is without MMU nobody should call it
> simply. Not saying your patch is wrong, but I'm trying to understand
> how exactly it got broken and the gcc error would show it immediately.
> 
> This is only called by memory.o and huge_memory.o and they both are
> built only if MMU=y.

Of course: Look for example at this page:
http://www.monstr.eu/wiki/doku.php?id=log:2011-01-18_11_51_49#linux_next

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
