Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1FCP6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:58:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39123 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab1FCP6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kxP01JrGgS1eAUJ0ucmZhQO+xeWi/htHU2JCpajo5jtFuckFCbjb2CLSFzyLeSwV48
         BhwBj5YQWawjusF2yYYMUWx35/Gz6ELS1X2MnM9i24PG814nwmUR+8zx+N6LtPTS35bF
         BA6AnZZMgrSVoZluZiR1YZkdNFoMsscloKinw=
MIME-Version: 1.0
In-Reply-To: <BANLkTikNC8F2TPY2TFHuHtU=-xhwef2ikw@mail.gmail.com>
References: <1307078050.4167.1.camel@phoenix>
	<BANLkTikNC8F2TPY2TFHuHtU=-xhwef2ikw@mail.gmail.com>
Date: Fri, 3 Jun 2011 23:58:03 +0800
Message-ID: <BANLkTin5oTOEq_t+NDHGOdtG5e0Mam9BLg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mtd: pxa3xx_nand: fix a memory leak
From: Lei Wen <adrian.wenl@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 9:02 PM, Daniel Mack <zonque@gmail.com> wrote:
> (Cc Lei Wen)
>
> On Fri, Jun 3, 2011 at 7:14 AM, Axel Lin <axel.lin@gmail.com> wrote:
>> In pxa3xx_nand_remove, we should call nand_release instead of
>> mtd_device_unregister to properly free bad block table memory
>> and bad block descriptor memory.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/mtd/nand/pxa3xx_nand.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
>> index 1fb3b3a..f7040ea 100644
>> --- a/drivers/mtd/nand/pxa3xx_nand.c
>> +++ b/drivers/mtd/nand/pxa3xx_nand.c
>> @@ -1119,7 +1119,7 @@ static int pxa3xx_nand_remove(struct platform_device *pdev)
>>        clk_put(info->clk);
>>
>>        if (mtd) {
>> -               mtd_device_unregister(mtd);
>> +               nand_release(mtd);
>>                kfree(mtd);
>>        }
>>        return 0;
>> --
>> 1.7.4.1
>>

Acked-by: Lei Wen <leiwen@marvell.com>
