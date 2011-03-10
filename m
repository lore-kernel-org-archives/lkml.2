Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1CJX2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:28:11 -0500
Received: from www.tglx.de ([62.245.132.106]:51133 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab1CJX2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:28:09 -0500
Date: Fri, 11 Mar 2011 00:27:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] sysfs: add more info to the oops dump
In-Reply-To: <20110310152201.bb621c3f.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1103110023310.2787@localhost6.localdomain6>
References: <20110310212746.GA3361@suse.de> <1299796027-3343-1-git-send-email-ext-phil.2.carmody@nokia.com> <1299796027-3343-2-git-send-email-ext-phil.2.carmody@nokia.com> <20110310143806.7542e929.akpm@linux-foundation.org> <alpine.LFD.2.00.1103102354530.2787@localhost6.localdomain6>
 <20110310230621.GH7975@esdhcp04044.research.nokia.com> <alpine.LFD.2.00.1103110012060.2787@localhost6.localdomain6> <20110310152201.bb621c3f.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, Andrew Morton wrote:
> On Fri, 11 Mar 2011 00:13:58 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > > It's more of an distraction than anything which is relevant to 99.999%
> > > > of the problems we have to deal with.
> > > 
> > > As I indicated before, I've previously thought that too, but thought I
> > > could 'fix' it by adding to it when I hit the once-in-three-years case.
> > 
> > The interesting question is:
> > 
> >  How did that info help and was it really the ultimate reason why you
> >  found the underlying bug ?
> 
> What happens with sysfs is that if a subsystem's handler is buggy, that
> tends to cause a crash within sysfs core code.  You get a stack trace
> which contains only VFS and sysfs functions - there is no symbol in the
> trace which permits you to identify the offending subsystem.

Reminds me of timer bugs, which popped up way after the fact that some
stupid driver reinitialized and active timer or freed memory
containing an active driver.

For some obvious reasons I haven't seen any of those bugs wasting my
time other than asking the bug reporter to enable debugobjects. :)

Thanks,

	tglx
