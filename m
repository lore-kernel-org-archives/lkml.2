Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab0FCCAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:00:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33289 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549Ab0FCCAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:00:12 -0400
Date: Thu, 3 Jun 2010 03:00:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, garzik@redhat.com
Subject: Re: Hang during boot, bisected to commit 96d60303fd
Message-ID: <20100603020006.GB19123@srcf.ucam.org>
References: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:49:27PM -0400, Marc Dionne wrote:
>    Since somewhere early in the 2.6.35 merge window I've been seeing a hang
>    during boot.  The hang last roughly 30 seconds and is followed by this:
> 
>    ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>    ata4.00: failed command: READ FPDMA QUEUED
>    ata4.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0 ncq 4096 in
>             res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>    ata4.00: status: { DRDY }
>    ata4: hard resetting link
>    ahci_is_device_present: status is: 80
>    ahci_is_device_present: status(2) is: 3
>    ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>    ata4.00: configured for UDMA/133
>    ata4.00: device reported invalid CHS sector 0
>    ata4: EH complete
> 
>    The system works normally once booted.  I had some time to do a bisect
>    today and it cleanly ended up pointing to this commit:
>        96d60303fd: ahci: Turn off DMA engines when there's no device attached
> 
>    Reverting the commit makes the system boot cleanly as before.  System has
>    an Intel ICH10 based board, in AHCI mode, disk is an Intel X25M SSD.

Hm, interesting. Jeff, any immediate ideas? I don't see this behaviour 
on my ICH10. Is there actually a device on ata4?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
