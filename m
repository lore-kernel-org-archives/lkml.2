Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1KGVHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:07:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44936 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1KGVHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:07:37 -0500
Date: Mon, 7 Nov 2011 21:07:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
Message-ID: <20111107210702.GA28781@srcf.ucam.org>
References: <1320680088-2584-1-git-send-email-matt@console-pimps.org>
 <20111107202324.GA27515@srcf.ucam.org>
 <4EB8413D.6030500@zytor.com>
 <20111107203752.GA27875@srcf.ucam.org>
 <4EB8436B.20603@zytor.com>
 <20111107204839.GA28261@srcf.ucam.org>
 <4EB84644.8060102@zytor.com>
 <20111107205859.GA28681@srcf.ucam.org>
 <4EB84734.3070006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB84734.3070006@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 01:01:40PM -0800, H. Peter Anvin wrote:
> On 11/07/2011 12:58 PM, Matthew Garrett wrote:
> > 
> >> However, "EFI stub in the kernel" doesn't mean "can't use an external
> >> bootloader."
> > 
> > Agreed. It just means that we're still plausibly going to need some 
> > handshaking between them. Alternatively, as long as the bootloader 
> > passes us the memory map, we can just ignore any E820 map it gives us 
> > anyway.
> > 
> 
> I know we need to be able to pass the initramfs in memory; anything else
> we need other than the normal EFI executable entry conditions?

If we're called before ExitBootServices(), no. If we're called after, 
we'll need the map from GetMemoryMap(). There's some other things that 
we may want to pass, such as option ROMs that we can get from firmware 
but which may not otherwise be mapped - I guess those could arguably be 
passed in the initramfs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
