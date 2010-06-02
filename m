Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab0FBPyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:54:19 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:54716 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758471Ab0FBPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:54:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kc8xwlnAWQBJ0CD6RerlSl0gvURiWv5PPtW6tumyvlZm8ihRUdhM3l/9uGkfs/zdnIxlsmZzThHKcpruiIcETcBbnB16IY0SfXG2gb+DuZGMbM4F1dKUS7vDmwekJpIJ;
Date: Wed, 2 Jun 2010 08:53:27 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
       Tejun Heo <tj@kernel.org>, Mike Habeck <habeck@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not
 already assigned
Message-ID: <20100602085327.71dfaca0@virtuousgeek.org>
In-Reply-To: <4C067D0B.7030804@zytor.com>
References: <4BEAF008.9030805@sgi.com>
	<201006011649.56074.bjorn.helgaas@hp.com>
	<4C0608C6.4090901@zytor.com>
	<201006020945.09107.bjorn.helgaas@hp.com>
	<4C067D0B.7030804@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jun 2010 17:47:23 +0200
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/02/2010 05:45 PM, Bjorn Helgaas wrote:
> > On Wednesday, June 02, 2010 01:31:18 am H. Peter Anvin wrote:
> >> On 06/01/2010 03:49 PM, Bjorn Helgaas wrote:
> >>>>
> >>>> BIOS still assigns the MMIO BAR's so the devices are alive.
> >>>
> >>> I'm sorry; I don't follow this.  BIOS assigns MMIO BARs regardless
> >>> of whether we have your patch.
> >>
> >> I'm assuming that that Mike is implying is that the allocation code runs
> >> out of I/O space and as a result shuts down the entire device.
> >
> > Yeah, that's why I asked about a deeper problem.  There's not really a
> > "shut down this device" flag, so the only way I can think of that we
> > might make a device completely unusable is if we release all the device
> > resources and then fail to reassign them.
> >
> > A concrete example, e.g., a dmesg log, would go a long ways toward
> > clarifying this.
> >
> 
> That's what I thought, which I guess means my original question to Mike 
> still stands...

I thought the whole reason for this was hotplug; we don't want to
exhaust I/O space unnecessarily by allocating resources for BARs the
BIOS didn't assign so we can keep them around for later hotplug
activity.

If there's some other issue, it's not too late to drop this patch.

Mike or Mike, can you clarify?

-- 
Jesse Barnes, Intel Open Source Technology Center
