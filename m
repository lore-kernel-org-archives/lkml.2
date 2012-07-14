Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2GNNJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 09:09:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:4484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab2GNNJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:09:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177304066"
Date: Sat, 14 Jul 2012 21:09:32 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel boot hangs on commit "switch fput to task_work_add"
Message-ID: <20120714130932.GA791@localhost>
References: <20120710141830.GA5385@localhost>
 <20120714130510.GC31729@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714130510.GC31729@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 02:05:10PM +0100, Al Viro wrote:
> On Tue, Jul 10, 2012 at 10:18:30PM +0800, wfg@linux.intel.com wrote:
> > Hi Al,
> > 
> > The linux-next kernel reliably hung after this line:
> > 
> > [    4.846260] debug: unmapping init [mem 0xffff88000182a000-0xffff8800019fffff]
> > 
> > And it's bisected to commit:
> > 
> >         commit 4a9ffe81385c2af04f296bea05482f34e02ea10d
> >         Author: Al Viro <viro@zeniv.linux.org.uk>
> >         Date:   Sun Jun 24 09:56:45 2012 +0400
> > 
> >             switch fput to task_work_add
> > 
> >             ... and schedule_work() for interrupt/kernel_thread callers
> >             (and yes, now it *is* OK to call from interrupt).
> > 
> > I tried add this debug aid:
> > 
> > init_post(void):
> > +       printk(KERN_WARNING "flush_delayed_fput\n");
> >         flush_delayed_fput();
> > +       printk(KERN_WARNING "flush_delayed_fput done\n");
> > 
> > And then it hangs after "flush_delayed_fput done". So it's not directly
> > freezing inside flush_delayed_fput()..
> 
> Could you post a stack trace, etc.?  I'll try to reproduce that one, obviously,
> but...

Yeah, I'm wondering (and will try) if it will help sending SYSRQ into
kvm guest. It's rather clueless without a back trace..

Thanks,
Fengguang
