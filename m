Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab1ELPkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:40:33 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:50096 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab1ELPkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:40:32 -0400
Message-ID: <4DCBFF4B.9030609@parrot.com>
Date: Thu, 12 May 2011 17:39:55 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Nitin Garg <nitingarg98@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bug in MTD NAND ONFI chipsize detection
References: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>	<20110511183322.da0739c9.akpm@linux-foundation.org>	<BANLkTikrqzpU8qZ5FUgG4HaBgZAvmbOHrQ@mail.gmail.com>	<BANLkTinGFDHj4s6nAXMiq8dYW_UO6W+YXg@mail.gmail.com>	<BANLkTin5X7d+_b5+7N5g941bz12jc+zMZA@mail.gmail.com>	<4DCB908C.80505@parrot.com> <BANLkTik37R8tSxc9_qmBT5a2m9mAA_2XKQ@mail.gmail.com>
In-Reply-To: <BANLkTik37R8tSxc9_qmBT5a2m9mAA_2XKQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Garg a écrit :
> I do not see any diff for mtd.
> 
ONFI spec say [1].

Why this doesn't apply to mtd ?


[1]
    3.1.2. Logical Unit Selection
Logical units within one target share a single data bus with the host. The host
shall ensure that
only one LUN is selected for data output to the host at any particular point in
time to avoid bus
contention.
The host selects a LUN for future data output by issuing a Read Status Enhanced
command to
that LUN. The Read Status Enhanced command shall deselect the output path for
all LUNs that
are not addressed by the command. The page register selected for output within
the LUN is
determined by the previous Read (Cache) commands issued, and is not impacted by Read
Status Enhanced.



> Regards,
> Nitin
> 
> On Thu, May 12, 2011 at 2:47 AM, Matthieu CASTET
> <matthieu.castet@parrot.com> wrote:
>> Hi,
>>
>>
>> What's the difference between one lun and multiple lun for mtd ?
>>
>> Aren't any command to select the current lun ?
>>
>> Matthieu
>>
>>
>> Nitin Garg a écrit :
>>> Why isn't my patch going through? re-sending again,
>>>
>>> Signed-off-by: Nitin Garg <nitingarg98@xxxxxxxx>
>>> ---
>>>  drivers/mtd/nand/nand_base.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
>>> index c54a4cb..cdf6015 100644
>>> --- a/drivers/mtd/nand/nand_base.c
>>> +++ b/drivers/mtd/nand/nand_base.c
>>> @@ -2892,7 +2892,7 @@ static int nand_flash_detect_onfi(struct
>>> mtd_info *mtd, struct nand_chip *chip,
>>>       mtd->writesize = le32_to_cpu(p->byte_per_page);
>>>       mtd->erasesize = le32_to_cpu(p->pages_per_block) * mtd->writesize;
>>>       mtd->oobsize = le16_to_cpu(p->spare_bytes_per_page);
>>> -     chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) * mtd->erasesize;
>>> +     chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
>>> le32_to_cpu(p->lun_count) * mtd->erasesize;
>>>       busw = 0;
>>>       if (le16_to_cpu(p->features) & 1)
>>>               busw = NAND_BUSWIDTH_16;
> 
