Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743Ab0JSHo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:44:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36382 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386Ab0JSHoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FBGuaSBk+ni9R2fyzJHqUesrFKEVXPoI8XeuBLaxp448usoiSeQBd9ASUS/6xtKQOv
         LpuitNKx6DfKnPnslfHCngP0ddaent1Kl1e/qU/FU35PpO35jAjevA7qpYz4v7TQ0iv1
         12F4hEQn+Nz9G/ivdxP5D+bkl/1fh/oC1zjlk=
MIME-Version: 1.0
In-Reply-To: <20101019071951.GB23839@pengutronix.de>
References: <1267546953-19319-1-git-send-email-u.kleine-koenig@pengutronix.de> <20101019071951.GB23839@pengutronix.de>
From: Ian Molton <ian@mnementh.co.uk>
Date: Tue, 19 Oct 2010 08:44:02 +0100
X-Google-Sender-Auth: 9VSAO6FV7rfGtrce8IWVPvBwnwU
Message-ID: <AANLkTikaoztadhmdD6asL+RLKj27NEa3cPp+fz-=j4+F@mail.gmail.com>
Subject: Re: [PATCH] mfd/tc6393xb: don't use devinit data from non-init function
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I already acked it... wonder where it went?

Acked-by: Ian Molton <ian@mnementh.co.uk>

:)

-- 
Ian Molton
Linux, Automotive, and other hacking:
http://www.mnementh.co.uk/



2010/10/19 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hello,
>
> On Tue, Mar 02, 2010 at 05:22:33PM +0100, Uwe Kleine-König wrote:
>> tc6393xb_mmc_resources (which was marked __devinitdata) is used in
>> tc6393xb_mmc_enable() and tc6393xb_mmc_resume() which both are functions
>> living in .text.  This is not save with CONFIG_HOTPLUG=n.
>>
>> This was introduced in
>>
>>       64e8867 (mfd: tmio_mmc hardware abstraction for CNF area)
>>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> Cc: Ian Molton <ian@mnementh.co.uk>
>> Cc: Magnus Damm <damm@opensource.se>
>> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ping
>
> Uwe
>> ---
>>  drivers/mfd/tc6393xb.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
>> index 4bc5a08..b057d8d 100644
>> --- a/drivers/mfd/tc6393xb.c
>> +++ b/drivers/mfd/tc6393xb.c
>> @@ -154,7 +154,7 @@ static struct resource __devinitdata tc6393xb_nand_resources[] = {
>>       },
>>  };
>>
>> -static struct resource __devinitdata tc6393xb_mmc_resources[] = {
>> +static struct resource tc6393xb_mmc_resources[] = {
>>       {
>>               .start  = 0x800,
>>               .end    = 0x9ff,
>> --
>> 1.7.0
>>
>>
>
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
