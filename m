Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1E3N1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:27:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65363 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1E3N1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ELqHc56gtV9CW88HlyyRbFJ+n22YCTKVvEJn6FifdbxOGEFaamMg9NZHMUvPGYIOey
         Djgmq3SY/MdDWEGYDuxoL+wOOmvaswFjWgHDmEI04HOK/SIOywN0S8Yk89gXJP0DxmNm
         zhJY860Lt11gqpeToWXcYzH0QtAWu+E4SoXJM=
MIME-Version: 1.0
In-Reply-To: <20110530125822.GD3409@pengutronix.de>
References: <1306758796-4254-1-git-send-email-daniel.blueman@gmail.com>
	<20110530125822.GD3409@pengutronix.de>
Date: Mon, 30 May 2011 21:27:09 +0800
Message-ID: <BANLkTinL3ZvaNhYnsRMZQ4zBRLx6_F-O6Q@mail.gmail.com>
Subject: Re: [PATCH] sdhci: fix undue iomem warning
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On 30 May 2011 20:58, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi Daniel,
>
>> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
>> index 936bbca..ae948b0 100644
>> --- a/drivers/mmc/host/sdhci-pci.c
>> +++ b/drivers/mmc/host/sdhci-pci.c
>> @@ -918,8 +918,9 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
>>               return ERR_PTR(-ENODEV);
>>       }
>>
>> -     if (pci_resource_len(pdev, bar) != 0x100) {
>> -             dev_err(&pdev->dev, "Invalid iomem size. You may "
>> +     int len = pci_resource_len(pdev, bar);
>> +     if (len != 0x100 && len != 0x200) {
>
> Hmmm,
>
> a) SDHC Specs (even v3) only mention 0x100, so this _is_ the standard.
>   Do the new cards (which ones?) have anything located in the extra
>   area?

This controller is a dual-slot one, so has two register sets (though
one set of pins aren't wired to a socket).

> b) your approach won't scale very well

True - a more scalable test would be to check for non-zero length and
a multiple of 256 bytes, would you say?

This would be in-tune with page 2 of:
http://www.sdcard.org/developers/tech/host_controller/simple_spec/Simplified_SD_Host_Controller_Spec.pdf

> so, I'd say it is better to keep the old way.
>
>> +             dev_warn(&pdev->dev, "Invalid iomem size. You may "
>>                       "experience problems.\n");
>
> I second turning the message into a warning, though.

If the latter method is preferred, I'll adjust the patch and resend.

Thanks,
  Daniel
-- 
Daniel J Blueman
