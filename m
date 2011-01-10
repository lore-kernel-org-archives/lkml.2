Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1AJRTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:19:00 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:39685 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754467Ab1AJRS4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:18:56 -0500
From: Philip Rakity <prakity@marvell.com>
To: Pierre Tardy <tardyp@gmail.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 10 Jan 2011 09:18:51 -0800
Subject: Re: [PATCH 2/3] mmc: add MMC_QUIRK_BROKEN_CLK_GATING
Thread-Topic: [PATCH 2/3] mmc: add MMC_QUIRK_BROKEN_CLK_GATING
Thread-Index: Acuw6nRB0Gz/VHCURVenxLYmD9y0sw==
Message-ID: <B4C48E6D-6EEA-4FC4-9FA5-35818F230E0C@marvell.com>
References: <cover.1294588491.git.tardyp@gmail.com>
 <4663ceeebbd267abb11515570ac17702a6a482f4.1294588491.git.tardyp@gmail.com>
 <ADE0108D-6DF1-4230-B7FB-39D7AC7F63D1@marvell.com>
 <AANLkTimSV07Kdk_xq3nhGa26-SF_u3gxCM+CUhmRJrib@mail.gmail.com>
In-Reply-To: <AANLkTimSV07Kdk_xq3nhGa26-SF_u3gxCM+CUhmRJrib@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 10, 2011, at 8:57 AM, Pierre Tardy wrote:

>> 
>> 
>> Since the code is not called that often could you change the above code to:
>> 
>>>       if (mmc_card_sdio(card))
>>>               return !(card->quirks & MMC_QUIRK_BROKEN_CLK_GATING);
> Well, The comment in the
>>        return true;
>> 
>> more obvious that quirk only applies to sdio.
> 
> Disagree.Actually, before this code, there is a pretty long comment,
> that explain that this quirk only apply to sdio.
> 
> If we figure out later that some sdcard does not like clock gating
> either, we could add this quirk to those bad sdcard as well.

I am okay with this -- if you resubmit -- just indicate the quirk is more generic than just sdio

> 
> Here is the whole resulting function. I think this is clear enough:
> 
> static bool mmc_host_may_gate_card(struct mmc_card *card)
> {
> 
>        /* If there is no card we may gate it */
>        if (!card)
>               return true;
>        /*
>        * Don't gate SDIO cards! These need to be clocked at all times
>        * since they may be independent systems generating interrupts
>        * and other events. The clock requests counter from the core will
>        * go down to zero since the core does not need it, but we will not
>        * gate the clock, because there is somebody out there that may still
>        * be using it.
>        */
>        return !(card->quirks & MMC_QUIRK_BROKEN_CLK_GATING);
> 
> 
> }
> Pierre


