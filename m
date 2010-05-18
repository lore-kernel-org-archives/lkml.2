Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab0ERPqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:46:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46562 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab0ERPqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:46:16 -0400
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>, Greg KH <gregkh@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
In-Reply-To: <4BF255F3.9040002@linux.intel.com>
References: <20100513120016.GG2169@shaohui> <20100513165603.GC25212@suse.de>
	 <1273773737.13285.7771.camel@nimitz> <20100513181539.GA26597@suse.de>
	 <1273776578.13285.7820.camel@nimitz>  <20100518054121.GA25298@shaohui>
	 <1274167625.17463.17.camel@nimitz>  <4BF255F3.9040002@linux.intel.com>
Content-Type: text/plain
Date: Tue, 18 May 2010 08:46:10 -0700
Message-Id: <1274197570.17463.30.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 10:55 +0200, Andi Kleen wrote:
> I liked Dave's earlier proposal to do a command line parameter like interface
> for "probe". Perhaps that can be done. It shouldn't need a lot of code.

After looking at the code, configfs doesn't look to me like it can be
done horribly easily.  It takes a least a subsystem and then a few
structures to get things up and running.  There also doesn't appear to
be a good subsystem to plug into.

> In fact there are already two different parser libraries for this:
> lib/parser.c and lib/params.c. One could chose the one that one likes
> better :-)

Agreed.  But, I do see why Greg is suggesting configfs here.
Superficially, it seems like a good configfs fit, but I think configfs
is only a good fit when you need to cram a _bunch_ of stuff into a _new_
interface.  Here, we have a relatively tiny amount of data that has half
of what it needs from an existing interface.  

-- Dave

