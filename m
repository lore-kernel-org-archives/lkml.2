Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1BSPMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 10:12:43 -0500
Received: from www.tglx.de ([62.245.132.106]:38657 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab1BSPMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 10:12:41 -0500
Date: Sat, 19 Feb 2011 16:12:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: KY Srinivasan <kys@microsoft.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
In-Reply-To: <6E21E5352C11B742B20C142EB499E048011738@TK5EX14MBXC124.redmond.corp.microsoft.com>
Message-ID: <alpine.LFD.2.00.1102191540290.2701@localhost6.localdomain6>
References: <1297799735-25917-1-git-send-email-kys@microsoft.com> <alpine.LFD.2.00.1102191046220.2701@localhost6.localdomain6> <6E21E5352C11B742B20C142EB499E048011738@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Feb 2011, KY Srinivasan wrote:
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > Please do not use probe_irq_on for dynamic irq allocation. Highjacking
> > the lower PIC irqs is really not a good idea. Depending on when this
> > runs, you might grab an irq required by a driver which gets loaded
> > later.
> > 
> > Could you please explain what you're trying to do here ?
> 
> The IRQ being allocated is for the VMBUS driver for Linux guests running on
> a Windows virtualization platform (Hyper-V hypervisor).
> The hypervisor is capable of notifying events on the VMBUS via
> a guest specified interrupt line. Prior to this patch,
> the code was statically selecting an interrupt line for
> use by VMBUS. One of the long standing review comments
> on  that code was to make this irq allocation dynamic and that
> is what this patch does. For the Linux guest running as a VM
> on Hyper-V, the concern you raise is not an issue.

That patch does a whole lot of useless crap. 

When grabbing some random irq from the PIC is not an issue, then
what's the point of this probing, retry loop and the comments about
racing ? What races here? That does not make sense at all.

I don't know why the previous reviewer wanted to have that
dynamic. That just does not make sense to me.

Btw, that whole interrupt handler with two tasklets, one of them
scheduling work is just screaming threaded interrupt handler.

Thanks,

	tglx
