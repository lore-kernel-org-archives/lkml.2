Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0GMQfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:35:46 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57018 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab0GMQfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:35:44 -0400
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux@arm.linux.org.uk,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100713154335.GB2815@barrios-desktop>
References: <20100712155348.GA2815@barrios-desktop>
	 <20100713093006.GB14504@cmpxchg.org>
	 <20100713154335.GB2815@barrios-desktop>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 13 Jul 2010 09:35:33 -0700
Message-ID: <1279038933.10995.9.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 00:43 +0900, Minchan Kim wrote:
> 3 is not a big deal than 2 about memory usage.
> If the system use memory space fully(MAX_PHYSMEM_BITS 31), it just consumes
> 1024(128 * 8) byte. So now I think best solution is 2. 
> 
> Russell. What do you think about it? 

I'm not Russell, but I'll tell you what I think. :)

Make the sections 16MB.  You suggestion to add the start/end pfns
_doubles_ the size of the structure, and its size overhead.  We have
systems with a pretty tremendous amount of memory with 16MB sections.

If you _really_ can't make the section size smaller, and the vast
majority of the sections are fully populated, you could hack something
in.  We could, for instance, have a global list that's mostly readonly
which tells you which sections need to be have their sizes closely
inspected.  That would work OK if, for instance, you only needed to
check a couple of memory sections in the system.  It'll start to suck if
you made the lists very long.

-- Dave

