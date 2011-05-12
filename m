Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab1ELMe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:34:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40069 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab1ELMe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P7Jw0d7HF9B64EkYzRJbZDwuz2QiVHrZs3DlXVp6cnprpdAGCB71HRcgNpM3UX4qBB
         SuOTszluBoCRxW0OSpcY0QDqm9PoJsor6CO4DxsK0ge4bvhWvzsk04/huZ0SA+IlyvXA
         DnMaI/K3JWpPcZGEMzthVf04Np5C22K3/Lkso=
MIME-Version: 1.0
In-Reply-To: <4DCB908C.80505@parrot.com>
References: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
	<20110511183322.da0739c9.akpm@linux-foundation.org>
	<BANLkTikrqzpU8qZ5FUgG4HaBgZAvmbOHrQ@mail.gmail.com>
	<BANLkTinGFDHj4s6nAXMiq8dYW_UO6W+YXg@mail.gmail.com>
	<BANLkTin5X7d+_b5+7N5g941bz12jc+zMZA@mail.gmail.com>
	<4DCB908C.80505@parrot.com>
Date: Thu, 12 May 2011 07:34:26 -0500
Message-ID: <BANLkTik37R8tSxc9_qmBT5a2m9mAA_2XKQ@mail.gmail.com>
Subject: Re: Bug in MTD NAND ONFI chipsize detection
From: Nitin Garg <nitingarg98@gmail.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not see any diff for mtd.

Regards,
Nitin

On Thu, May 12, 2011 at 2:47 AM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> Hi,
>
>
> What's the difference between one lun and multiple lun for mtd ?
>
> Aren't any command to select the current lun ?
>
> Matthieu
>
>
> Nitin Garg a écrit :
>> Why isn't my patch going through? re-sending again,
>>
>> Signed-off-by: Nitin Garg <nitingarg98@xxxxxxxx>
>> ---
>>  drivers/mtd/nand/nand_base.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
>> index c54a4cb..cdf6015 100644
>> --- a/drivers/mtd/nand/nand_base.c
>> +++ b/drivers/mtd/nand/nand_base.c
>> @@ -2892,7 +2892,7 @@ static int nand_flash_detect_onfi(struct
>> mtd_info *mtd, struct nand_chip *chip,
>>       mtd->writesize = le32_to_cpu(p->byte_per_page);
>>       mtd->erasesize = le32_to_cpu(p->pages_per_block) * mtd->writesize;
>>       mtd->oobsize = le16_to_cpu(p->spare_bytes_per_page);
>> -     chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) * mtd->erasesize;
>> +     chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
>> le32_to_cpu(p->lun_count) * mtd->erasesize;
>>       busw = 0;
>>       if (le16_to_cpu(p->features) & 1)
>>               busw = NAND_BUSWIDTH_16;
>
