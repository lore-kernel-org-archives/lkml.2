Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab1EaSvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:51:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56392 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab1EaSvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:51:44 -0400
Date: Tue, 31 May 2011 19:51:22 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        davej@redhat.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        eranian@google.com, penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110531185122.GA11998@srcf.ucam.org>
References: <1306269105.21443.20.camel@dan>
 <1306442367.2279.25.camel@dan>
 <20110531165252.GB8971@srcf.ucam.org>
 <4DE5360D.5070809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE5360D.5070809@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:40:13AM -0700, H. Peter Anvin wrote:
> On 05/31/2011 09:52 AM, Matthew Garrett wrote:
> > The BIOS E820 map, or the kernel representation? In either case, this 
> > isn't going to work well with EFI. There are regions that will be marked 
> > as available in the E820 map that we *mustn't* touch until we've entered 
> > EFI virtual mode.
> > 
> > (This is, clearly, insane).
> > 
> 
> I believe we could (should!) mark them reserved, not available, in the
> E820 map and free them later.

That was my original approach, but it requires that the bootloader be 
modified and it turns out that it's a lot harder to hand reserved 
regions back to the OS than it is to just reserve it in-kernel. The 
complete inflexibility of e820 is massively unhelpful here. It's just 
not possible to represent all of the EFI memory map data in it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
