Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0HTPoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:44:16 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65525 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab0HTPoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=ue38uz8ApYpb6Ksr70VJtV+dVSEqzAeQJo2RuQO9KPn37/TWoLBQhp8l8toch/+qMy
         +lAvF6GwKMWdwZzLbxRQXMyyte4tOqLBxIjy5ud2xSiIftQ6tTn2wFBAcE2G86kdvyHM
         4Vw4YlMbtMWLflEbGfq88+ge1hsHqJNLTcWF0=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1DE04AB3-1B9A-4962-8A13-AFC74A898D80@opensource.wolfsonmicro.com>
References: <1282269518.31048.2.camel@mola> <1DE04AB3-1B9A-4962-8A13-AFC74A898D80@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 20 Aug 2010 23:43:53 +0800
Message-ID: <AANLkTik-rkJjSD_cH15m6vfvrM_BAd_DfN+Nv5BRK5u3@mail.gmail.com>
Subject: Re: [PATCH 1/4] regulator/wm831x-dcdc: fix potential NULL dereference
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/20 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On 20 Aug 2010, at 02:58, Axel Lin <axel.lin@gmail.com> wrote:
>
>> pdata is dereferenced earlier than tested for being NULL.
>> Thus move the dereference of "pdata" below the check for NULL.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>> drivers/regulator/wm831x-dcdc.c |   36 ++++++++++++++++++++++++------------
>> 1 files changed, 24 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
>> index dbfaf59..ed66fac 100644
>> --- a/drivers/regulator/wm831x-dcdc.c
>> +++ b/drivers/regulator/wm831x-dcdc.c
>> @@ -501,14 +501,17 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
>> {
>>       struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
>>       struct wm831x_pdata *pdata = wm831x->dev->platform_data;
>> -     int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
>
> ARRAY_SIZE() isn't actually a dereference, it's evaluated at compile time.
Ah. You are right! Thanks.
Axel
