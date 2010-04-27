Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0D0B3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:29:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901Ab0D0B3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:29:08 -0400
Date: Mon, 26 Apr 2010 18:27:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>, Yinghai <yinghai.lu@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below   
 BIOS_END
In-Reply-To: <20100426170547.5d7daa47@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.1004261824570.3739@i5.linux-foundation.org>
References: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com> <20100426162517.4ad308ff@virtuousgeek.org> <a96459c7f3573eef81dd6d6c4e3dedd8.squirrel@www.zytor.com> <20100426170547.5d7daa47@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Apr 2010, Jesse Barnes wrote:
> 
> Glad we agree.  As I said (and echoing Bjorn), I think it would be best
> to reserve this space in a way that doesn't just use IORESOURCE_BUSY.
> We want and need to do allocations from the special region, so we
> should mark it as such.

I think Bjorn's patch to pcibios_align_resource() is really good and 
clever, and I think it should take care of the need for IORESOURCE_BUSY, 
no? We do want to let devices that are _already_ allocated there insert 
their resources, it's just that we never want to allocate new ones in the 
low 1M region.

Do we actually have a regression left with Bjorn's patch?

		Linus
