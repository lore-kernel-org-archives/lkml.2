Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1FCPbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:31:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39620 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1FCPbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qVxF02z7FFoEoOxIxX4d+Bf5CJfIIBTqhdrpS2Hr7NcmsQ18q/Mm+Y/+w2cKru5imI
         AbuOKeN49hydXacPekJwLwTI147XkykKbH95AYETfUwgFaiF0x1DEk6+G9OYJ2mCKJ0Z
         eqJ48DWyRYytOd3kVLpK7IJJ76DLQVJBWtFIk=
MIME-Version: 1.0
In-Reply-To: <BANLkTimpLKkfSJbeuM6kc7bUE+JybTmVrA@mail.gmail.com>
References: <1307106198-11965-1-git-send-email-zonque@gmail.com>
	<BANLkTimpLKkfSJbeuM6kc7bUE+JybTmVrA@mail.gmail.com>
Date: Fri, 3 Jun 2011 23:31:06 +0800
Message-ID: <BANLkTik1_cuo5UH995agoNYa2FdQ8Qasiw@mail.gmail.com>
Subject: Re: [PATCH] MTD: pxa3xx_nand: Fix blank page ECC mismatch
From: Lei Wen <adrian.wenl@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <David.Woodhouse@intel.com>,
        Lei Wen <leiwen@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>, stable@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also cc to MTD mailist
Cc: linux-mtd@lists.infradead.org

On Fri, Jun 3, 2011 at 11:04 PM, Lei Wen <adrian.wenl@gmail.com> wrote:
> On Fri, Jun 3, 2011 at 9:03 PM, Daniel Mack <zonque@gmail.com> wrote:
>> This bug was introduced in f8155a40 ("mtd: pxa3xx_nand: rework irq
>> logic") and causes the PXA3xx NAND controller fail to operate with NAND
>> flash that has empty pages. According to the comment in this block, the
>> hardware controller will report a double-bit error for empty pages,
>> which can and must be ignored.
>>
>> This patch restores the original behaviour of the driver.
>>
>> Signed-off-by: Daniel Mack <zonque@gmail.com>
>> Cc: Lei Wen <leiwen@marvell.com>
>> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
>> Cc: David Woodhouse <David.Woodhouse@intel.com>
>> Cc: stable@kernel.org
>> ---
>>  drivers/mtd/nand/pxa3xx_nand.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
>> index 0c6ed72..60167d1 100644
>> --- a/drivers/mtd/nand/pxa3xx_nand.c
>> +++ b/drivers/mtd/nand/pxa3xx_nand.c
>> @@ -687,6 +687,8 @@ static int pxa3xx_nand_read_page_hwecc(struct mtd_info *mtd,
>>                 * OOB, ignore such double bit errors
>>                 */
>>                if (is_buf_blank(buf, mtd->writesize))
>> +                       info->retcode = ERR_NONE;
>> +               else
>>                        mtd->ecc_stats.failed++;
>>        }
>>
>> --
>> 1.7.5.1
>>
>
> Acked-by: Lei Wen <leiwen@marvell.com>
>
