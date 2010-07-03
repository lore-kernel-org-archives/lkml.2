Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab0GCSbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 14:31:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52941 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab0GCSbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 14:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YKHsmDPJ759+S8P1qyNbqvXNHo4QG1g0MHqS9PIuGp8+UBqJvkKSMz8FIbiEyCp05g
         KRHy0GLRrW48lyKgRC1SPJL/gF93NDrKeC3AG8kgiFfwljArFpwHHeTHIh8zqNFOrvcu
         O6gz33slBA41JiQ4TzMFqmaovAym7Ka6mk580=
Message-ID: <4C2F8206.7050003@gmail.com>
Date: Sat, 03 Jul 2010 11:31:34 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jacek Poplawski <jacekpoplawski@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SH-D163C
References: <AANLkTinZfXXALWmmVPMHe-iJehQif7KC4tQCDdGge6g4@mail.gmail.com>
In-Reply-To: <AANLkTinZfXXALWmmVPMHe-iJehQif7KC4tQCDdGge6g4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2010 11:07 AM, Jacek Poplawski wrote:
> Hello,
>
> I bought new DVD burner and looks like I can't burn anything, because
> media is not recognized as burner.
>
> In logs I see:
> ata5.00: ATAPI: TSSTcorpDVD-ROM SH-D163C, SB00, max UDMA/100
> scsi 4:0:0:0: CD-ROM            TSSTcorp DVD-ROM SH-D163C SB00 PQ: 0 ANSI: 5
>
> Is this burner supported by kernel?
> If not, could you give me any hints how to add it at source code
> level? I assume it's a matter of adding new ID to some list? :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

not sure what/where is anything for the device, let alone if it's just a 
pci id that needs to be added to get it working..
git grep shows this:


git grep -n TSSTcorp
drivers/ata/libata-core.c:4305: /* Maybe we should just blacklist 
TSSTcorp... */
drivers/ata/libata-core.c:4306: { "TSSTcorp CDDVDW SH-S202H", "SB00", 
   ATA_HORKAGE_IVB, },
drivers/ata/libata-core.c:4307: { "TSSTcorp CDDVDW SH-S202H", "SB01", 
   ATA_HORKAGE_IVB, },
drivers/ata/libata-core.c:4308: { "TSSTcorp CDDVDW SH-S202J", "SB00", 
   ATA_HORKAGE_IVB, },
drivers/ata/libata-core.c:4309: { "TSSTcorp CDDVDW SH-S202J", "SB01", 
   ATA_HORKAGE_IVB, },
drivers/ata/libata-core.c:4310: { "TSSTcorp CDDVDW SH-S202N", "SB00", 
   ATA_HORKAGE_IVB, },
drivers/ata/libata-core.c:4311: { "TSSTcorp CDDVDW SH-S202N", "SB01", 
   ATA_HORKAGE_IVB, },
drivers/ide/ide-iops.c:214:     { "TSSTcorp CDDVDW SH-S202J"    , "SB00" 
        },
drivers/ide/ide-iops.c:215:     { "TSSTcorp CDDVDW SH-S202J"    , "SB01" 
        },
drivers/ide/ide-iops.c:216:     { "TSSTcorp CDDVDW SH-S202N"    , "SB00" 
        },
drivers/ide/ide-iops.c:217:     { "TSSTcorp CDDVDW SH-S202N"    , "SB01" 
        },
drivers/ide/ide-iops.c:218:     { "TSSTcorp CDDVDW SH-S202H"    , "SB00" 
        },
drivers/ide/ide-iops.c:219:     { "TSSTcorp CDDVDW SH-S202H"    , "SB01" 
        },
drivers/ide/ide-iops.c:259:             if (strstr(model, "TSSTcorp 
CDDVDW SH-S202")) {


I put together a patch, with the info you supplied(not sure if it 
works), but since you want to have a go at it, I wont send it out, and 
let you hack at it!!

hope this helps..

Justin P Mattock
