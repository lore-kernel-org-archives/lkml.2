Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0KXLbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:31:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63956 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab0KXLbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:31:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mrlAUqHraQTA4KEotI+25CZw2OGT1xOOg2DT0Vq2i2uKIdeORMzaKIzxWRFILcQtx0
         g39SeVg59l4CGEvZ3HujP+ilwUi5afJe4jGUpczZybu4p4eMJLEtm6irAmT4suYdilOS
         dU7GgYWikuYgOFLtNwhTj6TzBnjymkA/0s+uU=
MIME-Version: 1.0
In-Reply-To: <1290595882.3332.7.camel@odin>
References: <1290588263.7545.1.camel@mola>
	<1290595882.3332.7.camel@odin>
Date: Wed, 24 Nov 2010 19:31:14 +0800
Message-ID: <AANLkTikosO52KZ1DP2oAtKJTFja26xLUBw1jDND-j0fk@mail.gmail.com>
Subject: Re: [PATCH] ASoC: nuc900-ac97: fix a memory leak
From: Wan ZongShun <mcuos.com@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Liam Girdwood <lrg@slimlogic.co.uk>:
> On Wed, 2010-11-24 at 16:44 +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  sound/soc/nuc900/nuc900-ac97.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
>> index 293dc74..e00e39d 100644
>> --- a/sound/soc/nuc900/nuc900-ac97.c
>> +++ b/sound/soc/nuc900/nuc900-ac97.c
>> @@ -384,7 +384,6 @@ out0:
>>
>>  static int __devexit nuc900_ac97_drvremove(struct platform_device *pdev)
>>  {
>> -
>>       snd_soc_unregister_dai(&pdev->dev);
>>
>>       clk_put(nuc900_ac97_data->clk);
>> @@ -392,6 +391,7 @@ static int __devexit nuc900_ac97_drvremove(struct platform_device *pdev)
>>       release_mem_region(nuc900_ac97_data->res->start,
>>                               resource_size(nuc900_ac97_data->res));
>>
>> +     kfree(nuc900_ac97_data);
>>       nuc900_ac97_data = NULL;
>>
>>       return 0;
>
>
> Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

thanks!

> --
> Freelance Developer, SlimLogic Ltd
> ASoC and Voltage Regulator Maintainer.
> http://www.slimlogic.co.uk
>
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
