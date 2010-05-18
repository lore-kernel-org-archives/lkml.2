Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0ERHpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 03:45:31 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42760 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab0ERHpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 03:45:30 -0400
Date: Tue, 18 May 2010 16:44:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>, Greg KH <gregkh@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
Message-ID: <20100518074432.GB30313@linux-sh.org>
References: <20100513120016.GG2169@shaohui> <20100513165603.GC25212@suse.de> <1273773737.13285.7771.camel@nimitz> <20100513181539.GA26597@suse.de> <1273776578.13285.7820.camel@nimitz> <20100518054121.GA25298@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518054121.GA25298@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 01:41:21PM +0800, Shaohui Zheng wrote:
> On Thu, May 13, 2010 at 11:49:38AM -0700, Dave Hansen wrote:
> > On Thu, 2010-05-13 at 11:15 -0700, Greg KH wrote:
> > > >       echo "physical_address=0x40000000 numa_node=3" > memory/probe
> > > > 
> > > > I'd *GREATLY* prefer that over this new syntax.  The existing mechanism
> > > > is obtuse enough, and the ',3' makes it more so.
> > > > 
> > > > We should have the code around to parse arguments like that, too, since
> > > > we use it for the boot command-line.
> > > 
> > > If you are going to be doing something like this, please use configfs,
> > > that is what it is designed for, not sysfs.
> > 
> > That's probably a really good point, especially since configfs didn't
> > even exist when we made this 'probe' file thingy.  It never was a great
> > fit for sysfs anyway.
> > 
> > -- Dave
> 
> the configfs was introduced in 2005, you can refer to http://lwn.net/Articles/148973/.
> 
> I enabled the configfs, and I see that the configfs is not so popular as we expected,
> I mount configfs to /sys/kernel/config, I get an empty directory. It means that nobody is 
> using this file system, it is an interesting thing, is it means that configfs is deprecated?
> If so, it might not be nessarry to develop a configfs interface for hotplug.
> 
configfs is certainly not deprecated, but there are also not that many
users of it at present. dlm/ocfs2 were the first users as far as I
recall, and netconsole as well. The fact you have an empty directory just
indicates that you don't have support for any of these enabled.

Note that there are also a lot of present-day sysfs and debugfs users
that could/should be converted to configfs but haven't quite gotten there
yet. In the sysfs case abuses are hard to rollback once they've made
become part of the ABI, but that's not grounds for continuing sysfs abuse
once cleaner methods become available. Many of the sysfs abuses were
implemented before configfs existed.

You can also find usage guidelines and example implementations in
Documentation/filesystems/configfs, which should give you a pretty good
idea of whether it's a good interface fit for your particular problem or
not.

These days sysfs seems to be the new procfs. It certainly helps to put a
bit of planning in to the interface before you're invariably stuck with
an ABI that's barely limping along.
