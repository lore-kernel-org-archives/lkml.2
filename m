Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2APT4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:56:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54829 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2APT4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:56:31 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy+1DWUaOMormPHy7hCJxNfdxmiAnj8W0gqNTbeogNN4w@mail.gmail.com>
References: <20120109003255.GA6598@havoc.gtf.org> <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
 <4F12E57E.3090805@garzik.org> <1326676534.13517.3.camel@minggr>
 <1326691403.13517.21.camel@minggr> <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
 <CA+55aFy+1DWUaOMormPHy7hCJxNfdxmiAnj8W0gqNTbeogNN4w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 11:55:42 -0800
X-Google-Sender-Auth: RpccMQAKl5gqEfkYfNWYVdGH88U
Message-ID: <CA+55aFxvUvWHbJvconcjPmDhUVcCRGxxA-iD+HEngRSt4iox5g@mail.gmail.com>
Subject: Re: [git patches] libata updates for 3.3
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 11:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> and I do think that resume used to be faster in v3.2 than it is even
> with your patch. But maybe that's some rose-colored glasses.
>
> I'll recompile an old kernel to check.

Confirmed.

Plain v3.2 really *is* faster than current git, even current git with
your patch.

In v3.2 I get this:

 [   92.035600] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
 [   92.035610] ata_piix 0000:00:1f.2: setting latency timer to 64
 [   92.036213] sd 0:0:0:0: [sda] Starting disk
 [   93.060471] ata2.00: failed to resume link (SControl 0)
 [   93.379963] ata1.01: failed to resume link (SControl 0)
 [   93.535802] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 [   93.535815] ata1.01: SATA link down (SStatus 0 SControl 0)
 [   93.543968] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES)
filtered out
 [   93.544747] ata1.00: configured for UDMA/100
 [   93.916453] PM: resume of devices complete after 1883.974 msecs
 [   93.916677] PM: Finishing wakeup.
 [   94.086800] ata2.01: failed to resume link (SControl 0)
 [   94.098408] ata2.00: SATA link down (SStatus 4 SControl 0)
 [   94.098429] ata2.01: SATA link down (SStatus 0 SControl 0)

while current git (with your patch) gives me

 [  108.115373] ata_piix 0000:00:1f.2: setting latency timer to 64
 [  109.142010] ata2.00: failed to resume link (SControl 0)
 [  109.462004] ata1.01: failed to resume link (SControl 0)
 [  109.618065] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 [  109.618078] ata1.01: SATA link down (SStatus 0 SControl 0)
 [  109.626242] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES)
filtered out
 [  109.627060] ata1.00: configured for UDMA/100
 [  109.627240] sd 0:0:0:0: [sda] Starting disk
 [  110.170015] ata2.01: failed to resume link (SControl 0)
 [  110.181480] ata2.00: SATA link down (SStatus 4 SControl 0)
 [  110.181496] ata2.01: SATA link down (SStatus 0 SControl 0)
 [  110.182124] PM: resume of devices complete after 2066.945 msecs
 [  110.224533] PM: Finishing wakeup.

so old kernels used to be a tiny bit faster despite not doing that
async thing (still slower than I'd like: I'd think that we should be
able to resume devices in less than a second, but I don't know where
all the time goes)

             Linus
