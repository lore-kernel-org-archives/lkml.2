Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701Ab1ESUdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:33:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39833 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab1ESUdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:33:18 -0400
Date: Thu, 19 May 2011 21:33:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@vkernel.org, hpa@zytor.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] efi: Retain boot service code until after switching to
 virtual mode
Message-ID: <20110519203308.GA2106@srcf.ucam.org>
References: <1305826343-3302-1-git-send-email-mjg@redhat.com>
 <BANLkTi=fViUQ+7i3PopGH4jkEcvCUqkrMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=fViUQ+7i3PopGH4jkEcvCUqkrMg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 01:26:27PM -0700, Yinghai Lu wrote:

> how many entries are listed in memmap?

So far I've been seeing about 20 boot services entries at most.

> Did you test this system that have lots of those entries ? like > 128?

Do any exist?

> because efi_init() is called before memblock_x86_fill(), that means
> memblock array for reserved can not be doubled yet. --- no usable
> entries in memblock array for ram.

Mm. I guess this can be shifted later.

> > +        * get rid of it all at this point
> > +        */
> > +       free_efi_boot_services();
> > +
> 
> No, at that point memblock is not used any more.  after mm_init()/mem_init()
> 
> need to use free_bootmem_late() in free_efi_boot_services

Ah, ok.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
