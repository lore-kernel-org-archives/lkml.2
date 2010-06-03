Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab0FCCLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:11:13 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:35401 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518Ab0FCCLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OyVyvlOJLjMNZg/aOphe/X6yJz0jLXWVNHn178Itk8yz9N9iNwvoa3IWiXCMV00Kit
         CGz0lDMoplLsnzioF5Z4RnHnFrZ/FyHfzAjOkVnmb89GvSweL0floK4mlHY6ZZ7nFd0h
         Feqx9IC2UXv8oXCVtjln4h5/KJbJ782ZIzRyo=
MIME-Version: 1.0
In-Reply-To: <20100603020006.GB19123@srcf.ucam.org>
References: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com>
	<20100603020006.GB19123@srcf.ucam.org>
Date: Wed, 2 Jun 2010 22:11:09 -0400
Message-ID: <AANLkTikTvOU-f4bF_9aYcFCx5zyVxC-8HS1Wb4jFJSXa@mail.gmail.com>
Subject: Re: Hang during boot, bisected to commit 96d60303fd
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, garzik@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 10:00 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jun 02, 2010 at 09:49:27PM -0400, Marc Dionne wrote:
>>    Since somewhere early in the 2.6.35 merge window I've been seeing a hang
>>    during boot.  The hang last roughly 30 seconds and is followed by this:
>>
>>    ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>>    ata4.00: failed command: READ FPDMA QUEUED
>>    ata4.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0 ncq 4096 in
>>             res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>    ata4.00: status: { DRDY }
>>    ata4: hard resetting link
>>    ahci_is_device_present: status is: 80
>>    ahci_is_device_present: status(2) is: 3
>>    ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>    ata4.00: configured for UDMA/133
>>    ata4.00: device reported invalid CHS sector 0
>>    ata4: EH complete
>>
>>    The system works normally once booted.  I had some time to do a bisect
>>    today and it cleanly ended up pointing to this commit:
>>        96d60303fd: ahci: Turn off DMA engines when there's no device attached
>>
>>    Reverting the commit makes the system boot cleanly as before.  System has
>>    an Intel ICH10 based board, in AHCI mode, disk is an Intel X25M SSD.
>
> Hm, interesting. Jeff, any immediate ideas? I don't see this behaviour
> on my ICH10. Is there actually a device on ata4?
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org

Yes, ata4 is the Intel SSD:

ata4.00: ATA-7: INTEL SSDSA2MH080G1GC, 045C8610, max UDMA/133

Marc
