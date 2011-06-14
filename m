Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1FNPVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:21:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42622 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1FNPVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:21:14 -0400
Date: Tue, 14 Jun 2011 16:21:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Do not reserve boot services regions within
 reserved areas
Message-ID: <20110614152101.GA17773@srcf.ucam.org>
References: <4DF77832.9020407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF77832.9020407@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 05:03:14PM +0200, Maarten Lankhorst wrote:

> +		/* Could not reserve boot area */
> +		if (!size)
> +			continue;
> +
> +		printk(KERN_INFO PFX "Freeing boot area "
> +			"[0x%llx-0x%llx)\n", start, start+size);

Probably don't need the printk - we could be dumping a few hundred of 
those.

> -		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
> +		  "Kernel-defined memdesc (%lu) "
> +			"doesn't match the one from EFI(%lu)!\n",
> +			sizeof(efi_memory_desc_t), memmap.desc_size);

And drop this hunk. It's entirely valid for an implementation to do 
this, we should just delete the message entirely.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
