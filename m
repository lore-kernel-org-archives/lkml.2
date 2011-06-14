Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1FNPxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:53:54 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50138 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FNPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:53:51 -0400
Date: Tue, 14 Jun 2011 16:53:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Do not reserve boot services regions within
 reserved areas
Message-ID: <20110614155338.GA19469@srcf.ucam.org>
References: <4DF77832.9020407@gmail.com>
 <20110614152101.GA17773@srcf.ucam.org>
 <4DF77ECB.4030709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF77ECB.4030709@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 05:31:23PM +0200, Maarten Lankhorst wrote:
> Op 14-06-11 17:21, Matthew Garrett schreef:
> > On Tue, Jun 14, 2011 at 05:03:14PM +0200, Maarten Lankhorst wrote:
> >
> >> +		/* Could not reserve boot area */
> >> +		if (!size)
> >> +			continue;
> >> +
> >> +		printk(KERN_INFO PFX "Freeing boot area "
> >> +			"[0x%llx-0x%llx)\n", start, start+size);
> > Probably don't need the printk - we could be dumping a few hundred of 
> > those.
> Ok, I believe you are right about the succesful ones, since memblock=debug
> will let you see those anyhow.
> 
> Should I change the unsuccesful ones to use memblock_dbg instead of printk?
> In that case you can still debug it if needed. Same question for free path,
> change printk to memblock_dbg?

I'd prefer just not printing anything here. We're engaging in a bug 
workaround without any guarantee that the bug affects a machine, so 
increasing the message load may result in people thinking something's 
wrong even when everything's fine. Limiting it to memblock_dbg seems 
sane.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
