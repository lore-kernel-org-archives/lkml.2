Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0K2Sgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:36:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47119 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0K2Sgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:36:38 -0500
Date: Mon, 29 Nov 2010 18:36:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86/PCI: never allocate PCI space from the last 1M
	below 4G
Message-ID: <20101129183620.GA14591@srcf.ucam.org>
References: <20101129183009.11256.33739.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129183009.11256.33739.stgit@bob.kio>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:30:09AM -0700, Bjorn Helgaas wrote:
> 
> The last 1M before 4G contains the processor restart vector and usually
> the system ROM.  We don't know the actual ROM size; I chose 1M because
> that's how much Windows 7 appears to avoid.
> 
> Without this check, we can allocate PCI space that will never work.  On
> Matthew's HP 2530p, we put the Intel GTT "Flush Page" at the very last
> page, which causes a spontaneous power-off:
> 
>   pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff]
>   fffff000-ffffffff : Intel Flush Page (assigned by intel-gtt)
> 
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=23542
> Reported-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Tested-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
