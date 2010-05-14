Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab0ENWeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:34:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35976 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752495Ab0ENWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:34:07 -0400
Message-ID: <4BEDCFD9.7020202@sgi.com>
Date: Fri, 14 May 2010 15:34:01 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Habeck <habeck@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com>	<201005131256.17997.bjorn.helgaas@hp.com>	<4BEC5530.1000008@sgi.com>	<201005131402.30759.bjorn.helgaas@hp.com> <20100514152509.3aeb37b4@virtuousgeek.org>
In-Reply-To: <20100514152509.3aeb37b4@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jesse Barnes wrote:
> On Thu, 13 May 2010 14:02:30 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>>> This issue is not specific to x86, so I don't really like having
>>>> the implementation be x86-specific.
>>> I agree this isn't a x86 specific issue but given the 'norom'
>>> cmdline option is basically doing the same thing (but for pci
>>> Expansion ROM BARs) this code was modeled after it.

>> IMHO, we should fix both.
> 
> Yeah, that would be good.  Mike, have you looked at this at all?
> 
> Also, to clarify, this isn't affecting users today, right?  Or do you
> need all this I/O space for multiple IOHs and the drivers that bind to
> them in current UV systems?

We have customers that want to install more than 16 PCI-e cards right
now.  Our window of opportunity closes very soon (days), so either this
patch makes it in as is (or something close), or we wait for another
release cycle.  UV shipments start this month.

[I wouldn't mind working on an improvement for later.]

> 
> Fundamentally, until we have real dynamic PCI resource management (i.e.
> driver hooks for handling relocation, lazy allocation of resources at
> driver bind time, etc.) we're going to continue to need hacks like
> this.  However, we could make them slightly more automated by making
> "nobar" and "norom" the default on systems that typically need them,
> maybe with a DMI table.

It seems that BIOS changes are much more difficult.  The real solution
to this problem is for Card Vendors to not request I/O Bars if they
won't be using them.  But that's the hardest option of all to accomplish.

Thanks,
Mike
