Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab0EMSDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:03:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57514 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab0EMSDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:03:12 -0400
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
In-Reply-To: <20100513165603.GC25212@suse.de>
References: <20100513120016.GG2169@shaohui> <20100513165603.GC25212@suse.de>
Content-Type: text/plain
Date: Thu, 13 May 2010 11:02:17 -0700
Message-Id: <1273773737.13285.7771.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 09:56 -0700, Greg KH wrote:
> On Thu, May 13, 2010 at 08:00:16PM +0800, Shaohui Zheng wrote:
> > hotplug emulator:extend memory probe interface to support NUMA
> > 
> > Extend memory probe interface to support an extra paramter nid,
> > the reserved memory can be added into this node if node exists.
> > 
> > Add a memory section(128M) to node 3(boots with mem=1024m)
> > 
> >       echo 0x40000000,3 > memory/probe

I dunno.  If we're going to put multiple values into the file now and
add to the ABI, can we be more explicit about it?

	echo "physical_address=0x40000000 numa_node=3" > memory/probe

I'd *GREATLY* prefer that over this new syntax.  The existing mechanism
is obtuse enough, and the ',3' makes it more so.

We should have the code around to parse arguments like that, too, since
we use it for the boot command-line.

-- Dave

