Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab0FAE7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 00:59:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40873 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0FAE7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 00:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qcbSwhNS4r5Y4/aO/gS2ewRlzQVvXdfjw6qfzGaXeS2rOYPjNVDmikjqsRaflFD/n7
         S6ou5SqQr6ak3lBWwdnf+un6sswBa8uxwRiMPjL3czWyru/2qhWWdSCbeTZ4xvMJLHnT
         2WIhUXPy7f63slOeYqZRUcr+zgnZgVaT3ld34=
Message-ID: <4C0493C0.7000703@gmail.com>
Date: Mon, 31 May 2010 22:59:44 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: SSD + sata_nv + btrfs oops
References: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
In-Reply-To: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 09:04 PM, Dave Airlie wrote:
> Hi guys,
>
> I've been running an Intel SSD (the KS one) on my Dell XPS710 desktop
> machine, with btrfs on it.
>
> I'm not sure the btrfs oops isn't due to the disk/controller doing
> something bad (almost guaranteed).
>
> Attached the dmesg + config, using 2.6.34 + only drm patches.
>
> Jeff I'd be interested in knowing what is happening to the disk before
> btrfs oops.

ata2: EH in SWNCQ mode,QC:qc_active 0x7FFFFE03 sactive 0x7FFFFE03
ata2: SWNCQ:qc_active 0xFE00 defer_bits 0x7FFF0003 last_issue_tag 0xf
   dhfis 0x7E00 dmafis 0x200 sdbfis 0x0
ata2: ATA_REG 0x40 ERR_REG 0x0
ata2: tag : dhfis dmafis sdbfis sacitve
ata2: tag 0x9: 1 1 0 1
ata2: tag 0xa: 1 0 0 1
ata2: tag 0xb: 1 0 0 1
ata2: tag 0xc: 1 0 0 1
ata2: tag 0xd: 1 0 0 1
ata2: tag 0xe: 1 0 0 1
ata2: tag 0xf: 0 0 0 1
ata2.00: exception Emask 0x0 SAct 0x7ffffe03 SErr 0x1800000 action 0x6 
frozen
ata2: SError: { LinkSeq TrStaTrns }

Last line is probably the most informative, SATA link sequence error and 
transport state transition error. That's probably something bad 
happening at the low level between the controller and drive. Is this 
happening repeatedly?
