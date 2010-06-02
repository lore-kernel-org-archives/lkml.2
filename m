Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab0FBPpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:45:35 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:47599 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606Ab0FBPpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:45:32 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already assigned
Date: Wed, 2 Jun 2010 09:45:08 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <4BEAF008.9030805@sgi.com> <201006011649.56074.bjorn.helgaas@hp.com> <4C0608C6.4090901@zytor.com>
In-Reply-To: <4C0608C6.4090901@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006020945.09107.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 02, 2010 01:31:18 am H. Peter Anvin wrote:
> On 06/01/2010 03:49 PM, Bjorn Helgaas wrote:
> >>
> >> BIOS still assigns the MMIO BAR's so the devices are alive.
> >
> > I'm sorry; I don't follow this.  BIOS assigns MMIO BARs regardless
> > of whether we have your patch.
> 
> I'm assuming that that Mike is implying is that the allocation code runs 
> out of I/O space and as a result shuts down the entire device.

Yeah, that's why I asked about a deeper problem.  There's not really a
"shut down this device" flag, so the only way I can think of that we
might make a device completely unusable is if we release all the device
resources and then fail to reassign them.

A concrete example, e.g., a dmesg log, would go a long ways toward
clarifying this.

Bjorn
