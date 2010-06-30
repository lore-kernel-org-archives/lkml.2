Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab0F3Giw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 02:38:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40895 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab0F3Giu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:38:50 -0400
Date: Wed, 30 Jun 2010 08:38:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34 Northbridge Chipset Errors on HP Proliant 4 x Opteron
 in x86_64 mode
Message-ID: <20100630063844.GB27891@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeffrey Merkey <jeffmerkey@gmail.com>, linux-kernel@vger.kernel.org
References: <AANLkTingidlvRUaD4FwNDybaZ29Qrr_507Pto1vVqo-a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTingidlvRUaD4FwNDybaZ29Qrr_507Pto1vVqo-a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeffrey Merkey <jeffmerkey@gmail.com>
Date: Tue, Jun 29, 2010 at 03:13:03PM -0600

> On a 4 x Opteron HP Proliant Server with a CCISS array controller in
> x86_64 mode, under very heavy (saturated) disk IO, 2.6.34 reports the
> following error:
> 
> Jun 29 02:02:08  kernel: Northbridge Error, node 0, core: 0
> Jun 29 02:02:08  kernel: ECC/ChipKill ECC error.
> Jun 29 02:02:08  kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
> Jun 29 02:02:08  kernel: EDAC amd64: get_channel_from_ecc_syndrome:
> error reading F3x180.
> Jun 29 02:02:08  kernel: EDAC MC0: CE page 0xc7358, offset 0x280,
> grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac
> Jun 29 02:03:21  kernel: Northbridge Error, node 0
> Jun 29 02:03:21  kernel: ECC/ChipKill ECC error.
> Jun 29 02:03:21  kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
> Jun 29 02:03:21  kernel: EDAC amd64: get_channel_from_ecc_syndrome:
> error reading F3x180.

It looks like you don't have extended PCI config space accesses enabled
on that machine. Can you send me the whole dmesg?

> Jun 29 02:03:21  kernel: EDAC MC0: CE page 0xc7358, offset 0x280,
> grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac
> 
> The error is reproduceable by subjecting the server to excessive disk
> loads > 350 MB/S stream to disk.

DRAM ECC errors. It looks most probably like the first DIMM on node 0,
whichever that is, might be slowly failing.

Pinpointing it is not that straightforward, here's what you can do:

Try to figure which it is by looking at the silkscreen labels on the
motherboard. They're normally named like "DIMM_Ax" where x is in (1,
2, ...) or "DIMM_Bx" or a similar scheme. If the layout on the mobo is
sane, I'm guessing the first DIMM in that naming scheme should be it.
Try swapping it out to see if the errors disappear.

-- 
Regards/Gruss,
    Boris.
