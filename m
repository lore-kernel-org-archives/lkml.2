Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab0K1FR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 00:17:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:54404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0K1FR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 00:17:28 -0500
Date: Sat, 27 Nov 2010 21:17:49 -0800
From: Greg KH <gregkh@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: Re: [patch 2/2 v2] mm: add node hotplug emulation
Message-ID: <20101128051749.GA11474@suse.de>
References: <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com>
 <20101119003225.GB3327@shaohui>
 <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1011201827540.12889@chino.kir.corp.google.com>
 <20101121173438.GA3922@suse.de>
 <alpine.DEB.2.00.1011211346160.26304@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1011211505440.30377@chino.kir.corp.google.com>
 <20101122005658.GA6710@suse.de>
 <alpine.DEB.2.00.1011271750140.3764@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011271750140.3764@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 05:52:03PM -0800, David Rientjes wrote:
> On Sun, 21 Nov 2010, Greg KH wrote:
> 
> > > Add an interface to allow new nodes to be added when performing memory
> > > hot-add.  This provides a convenient interface to test memory hotplug
> > > notifier callbacks and surrounding hotplug code when new nodes are
> > > onlined without actually having a machine with such hotpluggable SRAT
> > > entries.
> > > 
> > > This adds a new debugfs interface at /sys/kernel/debug/hotplug/add_node
> > 
> > The rule for debugfs is "there are no rules", but perhaps you might want
> > to name "hotplug" a bit more specific for what you are doing?  "hotplug"
> > means pretty much anything these days, so how about s/hotplug/node/
> > instead as that is what you are controlling.
> > 
> > Just a suggestion...
> > 
> 
> Hmm, how strongly do you feel about that?  There's nothing node specific 
> in the memory hotplug code where this lives, so we'd probably have to 
> define the dentry elsewhere and even then it would only needed for 
> CONFIG_MEMORY_HOTPLUG.
> 
> I personally don't see this as a node debugging but rather memory hotplug 
> callback debugging.

Then name it as such, not the generic "hotplug" like you just did.
"mem_hotplug" would make sense, right?

thanks,

greg k-h
