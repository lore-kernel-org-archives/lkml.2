Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0DZSej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:34:39 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:50954 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0DZSeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:34:37 -0400
Date: Mon, 26 Apr 2010 11:34:36 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "R. Andrew Bailey" <bailey@akamai.com>, Yinghai <yinghai.lu@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below
	BIOS_END
Message-ID: <20100426183436.GV11130@hexapodia.org>
References: <4BC4E55B.7000103@oracle.com> <4BCE8E3E.4030809@oracle.com> <20100421193120.GD11130@hexapodia.org> <201004231705.25659.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004231705.25659.bjorn.helgaas@hp.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 05:05:24PM -0600, Bjorn Helgaas wrote:
> On Wednesday 21 April 2010 01:31:20 pm Andy Isaacson wrote:
> > On Tue, Apr 20, 2010 at 10:33:50PM -0700, Yinghai wrote:
> > > Update e820 at first, and later put them resource tree.
> > > Reserved that early, will not be allocated to unassigned PCI BAR
> > > 
> > > v3: remove probe_roms() that is not needed, because whole range is reserved
> > > 	 already
> > 
> > Test booted this patch series on the problematic t3400, seems to work
> > fine.  dmesg attached to bug 15744.
> 
> Thanks for testing (again).  I'm not confident that this series is
> going to be successful, so I started looking for other approaches.
> 
> I can't reproduce the exact problem you're seeing, but in my
> kludged-up attempt, the patch below is enough to keep us from
> assigning the space below 1MB to a device.
> 
> Would you guys (Andy & Andy, what a coincidence :-)) mind giving
> it a try?  This is intended to work on top of current upstream,
> with no other patches required.
> 
> Bjorn
> 
> 
> commit 7fb707eb97fdf6dc4fa4b127f127f8d00223afc7
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Fri Apr 23 15:22:10 2010 -0600
> 
> x86/PCI: never allocate PCI MMIO resources below BIOS_END
>     
> When we move a PCI device or assign resources to a device not configured
> by the BIOS, we want to avoid the BIOS region below 1MB.  Note that if the
> BIOS places devices below 1MB, we leave them there.

Works for me.  dmesg at
https://bugzilla.kernel.org/attachment.cgi?id=26150

-andy
