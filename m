Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0GAG0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 02:26:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59335 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab0GAG0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 02:26:12 -0400
Date: Thu, 1 Jul 2010 08:26:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34 Northbridge Chipset Errors on HP Proliant 4 x Opteron
 in x86_64 mode
Message-ID: <20100701062605.GA1051@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeffrey Merkey <jeffmerkey@gmail.com>, linux-kernel@vger.kernel.org
References: <AANLkTingidlvRUaD4FwNDybaZ29Qrr_507Pto1vVqo-a@mail.gmail.com>
 <20100630063844.GB27891@liondog.tnic>
 <AANLkTilrpslDI4hFzbZRTJCd3JnkbGqN7fvsMEl9wJ9_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTilrpslDI4hFzbZRTJCd3JnkbGqN7fvsMEl9wJ9_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeffrey Merkey <jeffmerkey@gmail.com>
Date: Wed, Jun 30, 2010 at 01:21:04PM -0600

> >
> > It looks like you don't have extended PCI config space accesses enabled
> > on that machine. Can you send me the whole dmesg?
> >
> 
> Here is the complete dmesg log of the Northbridge chip error messages.
>  The drives report IO problems before the chip error message happens.

Jun 29 02:02:08 cloudstream kernel: Northbridge Error, node 0, core: 0
Jun 29 02:02:08 cloudstream kernel: ECC/ChipKill ECC error.
Jun 29 02:02:08 cloudstream kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
Jun 29 02:02:08 cloudstream kernel: EDAC amd64: get_channel_from_ecc_syndrome: error reading F3x180.
Jun 29 02:02:08 cloudstream kernel: EDAC MC0: CE page 0xc7358, offset 0x280, grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac
Jun 29 02:03:21 cloudstream kernel: Northbridge Error, node 0
Jun 29 02:03:21 cloudstream kernel: ECC/ChipKill ECC error.
Jun 29 02:03:21 cloudstream kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
Jun 29 02:03:21 cloudstream kernel: EDAC amd64: get_channel_from_ecc_syndrome: error reading F3x180.
Jun 29 02:03:21 cloudstream kernel: EDAC MC0: CE page 0xc7358, offset 0x280, grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac

Right, this is the ECC happening. I asked about the dmesg because of
the "error reading F3x180" but you have a K8 machine so no extended PCI
config space there. And the error message is wrong there, I will move
that F3x180 read behind a family check since it makes no sense to access
that on K8.

Thanks.

-- 
Regards/Gruss,
    Boris.
