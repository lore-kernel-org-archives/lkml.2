Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab1FWVdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:33:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50169 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759815Ab1FWVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QlhVNMWTf3DFATOpIc23C/YhiYVwn393butZhD7x7N+DjB3GWo6zqkvV0D7/jZXj35
         xdxX7gRvPXwOpzd7jOwHpzXtvbOPKNEGr/ZR5bT6GjC64RP3MMHKc/Td88fiAOxj7Q1N
         SiSOrYFPhfOZvlKgspQPcUBBGcBg87HHf6noY=
Message-ID: <4E03B110.7060708@garzik.org>
Date: Thu, 23 Jun 2011 17:33:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 05/35] drivers/ata changes for SMBIOS and System Firmware
References: <20110623172240.27628.71518.sendpatchset@prarit.bos.redhat.com>
In-Reply-To: <20110623172240.27628.71518.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 01:22 PM, Prarit Bhargava wrote:
> drivers/ata changes for SMBIOS and System Firmware
>
> As part of the new SMBIOS and System Firmware code:
>
> - Replace old dmi* structures and functions with new sysfw* and smbios*
> structures and functions in individual drivers
> - cleanup sysfw_id lookup tables
> - cleanup of includes for dmi.h and mod_devicetable.h which were included in
> some files that did not need them
>
> Signed-off-by: Prarit Bhargava<prarit@redhat.com>
> ---
>   drivers/ata/acard-ahci.c  |    1 -
>   drivers/ata/ahci.c        |  177 +++++++++++++++++++++++----------------------
>   drivers/ata/ata_piix.c    |  156 +++++++++++++++++++++++-----------------
>   drivers/ata/pata_ali.c    |   18 +++---
>   drivers/ata/pata_cs5530.c |   12 ++--
>   drivers/ata/pata_rdc.c    |    1 -
>   drivers/ata/pata_sch.c    |    1 -
>   drivers/ata/pata_via.c    |   14 ++--
>   drivers/ata/sata_sil.c    |   19 +++---
>   9 files changed, 210 insertions(+), 189 deletions(-)



>   #ifdef CONFIG_PM
> +bool sysfw_match(int field, const char *str)
> +{
> +	const char *info = sysfw_lookup(field);
> +
> +	if (info == NULL || str == NULL)
> +		return info == str;
> +
> +	return !strcmp(info, str);
> +}

It is surprising that nobody else needed this.  I would rather that this 
sort of thing go into the generic code, where it lived prior to this change.

Either way, though,

Acked-by: Jeff Garzik <jgarzik@redhat.com>

I presume you'll merge this at the same time as the rest of the rename 
changes.

