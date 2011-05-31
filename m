Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab1EaQxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:53:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34872 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab1EaQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:53:15 -0400
Date: Tue, 31 May 2011 17:52:52 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davej@redhat.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, eranian@google.com,
        penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, hpa@zytor.com,
        Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        pageexec@freemail.hu, Ingo Molnar <mingo@elte.hu>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110531165252.GB8971@srcf.ucam.org>
References: <1306269105.21443.20.camel@dan>
 <1306442367.2279.25.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306442367.2279.25.camel@dan>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 04:39:27PM -0400, Dan Rosenberg wrote:

> 1. I'm nearly finished a first draft of code to parse the BIOS E820
> memory map to determine where it's safe to place the randomized kernel.
> This code accounts for overlapping regions, as well as potential
> conflicts in region types (free vs. reserved, etc.), in favor of
> non-free types.  The end result is, I'll have a reasonable upper bound.

The BIOS E820 map, or the kernel representation? In either case, this 
isn't going to work well with EFI. There are regions that will be marked 
as available in the E820 map that we *mustn't* touch until we've entered 
EFI virtual mode.

(This is, clearly, insane).

One other thing is that when we've entered EFI virtual mode we'll have 
remapped various parts of the EFI memory map into virtual address space. 
There's no way to update these mappings later. If we want kexec to work 
then there has to be a mechanism for ensuring that these mappings can be 
provided to the second kernel and for it to preserve them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
