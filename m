Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0KRGYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 01:24:55 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44751 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0KRGYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 01:24:54 -0500
Date: Thu, 18 Nov 2010 15:24:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, ak@linux.intel.com,
        shaohui.zheng@linux.intel.com, Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface to support NUMA
Message-ID: <20101118062416.GC17539@linux-sh.org>
References: <20101117020759.016741414@intel.com> <20101117021000.916235444@intel.com> <1290019807.9173.3789.camel@nimitz> <alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com> <20101118044850.GC2408@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118044850.GC2408@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:48:50PM +0800, Shaohui Zheng wrote:
> On Wed, Nov 17, 2010 at 01:18:50PM -0800, David Rientjes wrote:
> > Then, export the amount of memory that is actually physically present in 
> > the e820 but was truncated by mem= and allow users to hot-add the memory 
> > via the probe interface.  Add a writeable 'node' file to offlined memory 
> > section directories and allow it to be changed prior to online.
> 
> for memory offlining, it is a known diffcult thing, and it is not supported 
> well in current kernel, so I do not suggest to provide the offline interface
> in the emulator, it just take more pains. We can consider to add it when
> the memory offlining works well.
> 
This is all stuff that the memblock API can deal with, I'm not sure why
there seems to be an insistence on wedging all manner of unrelated bits
in to e820. Many platforms using memblock today already offline large
amounts of contiguous physical memory for use in drivers, if you were to
follow this scheme and simply layer a node creation shim on top of that
you would end up with something that is almost entirely generic.
