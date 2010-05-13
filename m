Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358Ab0EMSpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:45:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:54988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab0EMSpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:45:19 -0400
Date: Thu, 13 May 2010 11:05:51 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.com,
       fengguang.wu@intel.com, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 3/7] NUMA hotplug emulator
Message-ID: <20100513180550.GA26440@suse.de>
References: <20100513114835.GD2169@shaohui>
 <20100513165511.GB25212@suse.de>
 <1273773292.13285.7755.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273773292.13285.7755.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:54:52AM -0700, Dave Hansen wrote:
> On Thu, 2010-05-13 at 09:55 -0700, Greg KH wrote:
> > > Add a sysfs entry "probe" under /sys/devices/system/node/:
> > > 
> > >  - to show all fake offlined nodes:
> > >     $ cat /sys/devices/system/node/probe
> > > 
> > >  - to hotadd a fake offlined node, e.g. nodeid is N:
> > >     $ echo N > /sys/devices/system/node/probe
> > 
> > As you are trying to add a new sysfs file, please create the matching
> > Documentation/ABI/ file as well.
> > 
> > Also note that sysfs files are "one value per file", which I don't think
> > this file follows, right?
> 
> I think in this case, it was meant to be a list of acceptable parameters
> rather than a set of values, kinda like /sys/power/state.  Instead, I
> guess we could have:
> 
> 	/sys/devices/system/node/probeable/3
> 	/sys/devices/system/node/probeable/43
> 	/sys/devices/system/node/probeable/65
> 	/sys/devices/system/node/probeable/5145
> 
> and the knowledge that you need to pick one of those to echo
> into /sys/devices/system/node/probe.  But, it's a lot more self
> explanatory if you 'cat /sys/devices/system/node/probe', and then pick
> one of those to echo back into the file.
> 
> Seems like a decent place to violate the "rule". :)

How big would this "list" be?  What will it look like exactly?

thanks,

greg k-h
