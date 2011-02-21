Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1BUP5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:57:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:37858 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab1BUP5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:57:17 -0500
Date: Mon, 21 Feb 2011 07:43:11 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Message-ID: <20110221154311.GA446@suse.de>
References: <1297799735-25917-1-git-send-email-kys@microsoft.com>
 <alpine.LFD.2.00.1102191046220.2701@localhost6.localdomain6>
 <6E21E5352C11B742B20C142EB499E048011738@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <alpine.LFD.2.00.1102191540290.2701@localhost6.localdomain6>
 <6E21E5352C11B742B20C142EB499E048011787@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <alpine.LFD.2.00.1102201705380.2701@localhost6.localdomain6>
 <6E21E5352C11B742B20C142EB499E04801191C@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <alpine.LFD.2.00.1102211200270.2701@localhost6.localdomain6>
 <6E21E5352C11B742B20C142EB499E048013C67@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <alpine.LFD.2.00.1102211549340.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102211549340.2701@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 03:51:56PM +0100, Thomas Gleixner wrote:
> On Mon, 21 Feb 2011, KY Srinivasan wrote:
> > > > > There are various ways to solve that proper.
> > > > >
> > > > >  - You can provide the interrupt number from ACPI/PCI or whatever your HV
> > > > >    provides as enumeration.
> > > > >
> > > > >  - Use a fixed vector like XEN does for the event channel
> > > > >
> > > > >  - Use dynamic allocation in the IOAPIC space like the kernel does for
> > > > >    MSI(-X)
> > > > >
> > > > > Thanks,
> > > > >
> > > > > 	tglx
> > > >
> > > > I am not claiming that what I have done here is the best possible solution.
> > > > However, I will submit to you that it is better than what we had here
> > > > prior to this patch.  I will address this and a  whole lot of other issues
> > > > in future patches.
> > > 
> > > No, it's _NOT_ better in any way. You trade breaking your PV thing
> > > against breaking random other drivers. Care to explain why you think
> > > that's better ?
> > 
> > The root device for the VM is bound to the PV driver on some distributions.
> > So, if we cannot load the PV drivers, we do not have a system that boots.
> > In general, the system performance without these PV drivers is so poor that
> > for all practical purposes, having the PV drivers is almost a requirement
> > for having a useable system. While the platform supports configuration of the VM with
> > some emulated devices, it is not a recommended configuration (because of
> > performance reasons) for Linux virtual machines on the Hyper-V platform.
> 
> It does not matter whether it's recommended or not. If it results in a
> non usable emulated device it's broken. Just imagine you grab the
> serial interrupt, which results in not having a debug console. Not at
> all acceptable.
>  
> > I have spent significantly more time debating this patch than
> > developing this patch that I still think improves the current
> > driver. I will leave it to Greg and other powers that be to decide
> > if this patch will be accepted. Let me know what your verdict is.
> 
> As I said, any other clean solution (and I pointed out 3) over this
> hack.

Yeah, that sounds like the best solution, let's not cause accidental
breakage of systems that were working already.

KY, care to fix this up properly now?  There's no rush to take your
previous patch, as that is working ok for now, right?

thanks,

greg k-h
