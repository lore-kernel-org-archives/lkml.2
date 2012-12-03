Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2LCL5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:57:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53564 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab2LCL5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:57:39 -0500
Date: Mon, 3 Dec 2012 12:57:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ata1: COMRESET failed
Message-ID: <20121203115734.GA32243@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Slaby <jslaby@suse.cz>, jgarzik@pobox.com,
	linux-ide@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <508A7A8A.7030908@suse.cz>
 <50BC8A1C.8070805@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50BC8A1C.8070805@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 12:16:44PM +0100, Jiri Slaby wrote:
> On 10/26/2012 01:56 PM, Jiri Slaby wrote:
> > Hello,
> > 
> > at every boot I'm seeing:
> > 
> > At 5th second:
> > ata1: link is slow to respond, please be patient (ready=0)
> > 
> > At 10th second:
> > ata1: COMRESET failed (errno=-16)
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> > ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> > ata1.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
> > ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
> > ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> > ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> > ata1.00: configured for UDMA/133
> > scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
> > 
> > 
> > So that I have to wait 5 s for the disk to come up. I tried 3.4.15 and
> > 3.6.3, both with the same result.
> > 
> > 00:1f.2 SATA controller [0106]: Intel Corporation 7 Series Chipset
> > Family 6-port SATA Controller [AHCI mode] [8086:1e03] (rev 04)
> > 
> > Any ideas what is going on?
> 
> Anybody? I also tried 3.0, it's there too. And libahci.skip_host_reset=1
> works around the issue.

FWIW, I had the same issue on an AMD chipset at the old job. It needs to
reset SATA link for some reason, probably BIOS programs it wrongly...

+ Alan.

-- 
Regards/Gruss,
    Boris.
