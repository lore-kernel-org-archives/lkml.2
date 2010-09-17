Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0IQBAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 21:00:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:6172 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab0IQBAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 21:00:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,379,1280732400"; 
   d="scan'208";a="555286117"
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
From: ykzhao <yakui.zhao@intel.com>
To: "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <4C91C44F.40700@cn.fujitsu.com>
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
	 <4C91C44F.40700@cn.fujitsu.com>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Fri, 17 Sep 2010 08:55:18 +0800
Message-Id: <1284684918.13201.114.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 15:16 +0800, Miao Xie wrote:
> On Thu, 16 Sep 2010 08:48:25 +0200 (cest), Andi Kleen wrote:
> >> When the dest and the src do overlap and the memory area is large, memmove
> >> of
> >> x86_64 is very inefficient, and it led to bad performance, such as btrfs's
> >> file
> >> deletion performance. This patch improved the performance of memmove on
> >> x86_64
> >> by using __memcpy_bwd() instead of byte copy when doing large memory area
> >> copy
> >> (len>  64).
> >
> >
> > I still don't understand why you don't simply use a backwards
> > string copy (with std) ? That should be much simpler and
> > hopefully be as optimized for kernel copies on recent CPUs.
> 
> But according to the comment of memcpy, some CPUs don't support "REP" instruction,

Where do you find that the "REP" instruction is not supported on some
CPUs? The comment in arch/x86/lib/memcpy_64.s only states that some CPUs
will run faster when using string copy instruction. 
  
> so I think we must implement a backwards string copy by other method for those CPUs,
> But that implement is complex, so I write it as a function -- __memcpy_bwd().

Will you please look at tip/x86/ tree(mem branch)? The memory copy on
x86_64 is already optimized. 

thanks.
    Yakui
> 
> Thanks!
> Miao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

