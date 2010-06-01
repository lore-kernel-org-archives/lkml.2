Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab0FAFCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:02:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46286 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0FAFCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wn4dF+hbSNX1EflY9OsttLODffHL68GeA5XIgpmoiVkaG/2XsObyUMYyCtBUcQo8r7
         E0W0dcfNFCHeeoo6p6ijNLnfMT6uJB8Ayvo+T45NRUOV5bN6jA6Vf3DK1SIMrSpzOZ6Z
         jXIcRVQ85aoeMDLXZXdpoWx/EbGJnD9Umuyvo=
MIME-Version: 1.0
In-Reply-To: <4C0493C0.7000703@gmail.com>
References: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
	<4C0493C0.7000703@gmail.com>
Date: Tue, 1 Jun 2010 15:02:11 +1000
Message-ID: <AANLkTilrjgoGLaXsaDhCxKwgw6d71wnO4X7O9_lR1wfD@mail.gmail.com>
Subject: Re: SSD + sata_nv + btrfs oops
From: Dave Airlie <airlied@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 2:59 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 05/31/2010 09:04 PM, Dave Airlie wrote:
>>
>> Hi guys,
>>
>> I've been running an Intel SSD (the KS one) on my Dell XPS710 desktop
>> machine, with btrfs on it.
>>
>> I'm not sure the btrfs oops isn't due to the disk/controller doing
>> something bad (almost guaranteed).
>>
>> Attached the dmesg + config, using 2.6.34 + only drm patches.
>>
>> Jeff I'd be interested in knowing what is happening to the disk before
>> btrfs oops.
>
> ata2: EH in SWNCQ mode,QC:qc_active 0x7FFFFE03 sactive 0x7FFFFE03
> ata2: SWNCQ:qc_active 0xFE00 defer_bits 0x7FFF0003 last_issue_tag 0xf
>  dhfis 0x7E00 dmafis 0x200 sdbfis 0x0
> ata2: ATA_REG 0x40 ERR_REG 0x0
> ata2: tag : dhfis dmafis sdbfis sacitve
> ata2: tag 0x9: 1 1 0 1
> ata2: tag 0xa: 1 0 0 1
> ata2: tag 0xb: 1 0 0 1
> ata2: tag 0xc: 1 0 0 1
> ata2: tag 0xd: 1 0 0 1
> ata2: tag 0xe: 1 0 0 1
> ata2: tag 0xf: 0 0 0 1
> ata2.00: exception Emask 0x0 SAct 0x7ffffe03 SErr 0x1800000 action 0x6
> frozen
> ata2: SError: { LinkSeq TrStaTrns }
>
> Last line is probably the most informative, SATA link sequence error and
> transport state transition error. That's probably something bad happening at
> the low level between the controller and drive. Is this happening
> repeatedly?
>

from another boot I do see another one.

ata2: EH in SWNCQ mode,QC:qc_active 0x1FF sactive 0x1FF
ata2: SWNCQ:qc_active 0x7F defer_bits 0x180 last_issue_tag 0x6
  dhfis 0x3F dmafis 0x8 sdbfis 0x0
ata2: ATA_REG 0x41 ERR_REG 0x84
ata2: tag : dhfis dmafis sdbfis sacitve
ata2: tag 0x0: 1 0 0 1
ata2: tag 0x1: 1 0 0 1
ata2: tag 0x2: 1 0 0 1
ata2: tag 0x3: 1 1 0 1
ata2: tag 0x4: 1 0 0 1
ata2: tag 0x5: 1 0 0 1
ata2: tag 0x6: 0 0 0 1
ata2.00: exception Emask 0x1 SAct 0x1ff SErr 0x3800000 action 0x6 frozen

So yes it seems to happen quite a bit, I'm wondering is SWNCQ is
something I should be disabling for this controller.

Dave.
