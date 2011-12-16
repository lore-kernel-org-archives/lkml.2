Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab1LPEm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:42:28 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:50024 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760065Ab1LPEm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:42:27 -0500
From: Bing Zhao <bzhao@marvell.com>
To: NeilBrown <neilb@suse.de>, Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@laptop.org>,
        Joe Woodward <jw@terrafix.co.uk>, Chris Ball <cjb@laptop.org>
Date: Thu, 15 Dec 2011 20:39:28 -0800
Subject: RE: [PATCH] mmc/sdio: don't allow interface to runtime-suspend
 until probe is finished.
Thread-Topic: [PATCH] mmc/sdio: don't allow interface to runtime-suspend
 until probe is finished.
Thread-Index: Acy7qGdRDNaFOoLkTQylajZ5Eyj3LwAAld1g
Message-ID: <477F20668A386D41ADCC57781B1F704308185E3505@SC-VEXCH1.marvell.com>
References: <20111205125416.6093ecd8@notabene.brown>
	<CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
	<20111206060654.0e8bebe0@notabene.brown>
	<CAK=WgbbqgAYZ8uurf+xVyCxfZxoHcLdytxzdUNtoP9VNYPd57A@mail.gmail.com>
	<20111210181546.6da7099a@notabene.brown>
	<CAK=WgbbZU=NJupPCeXfy5WcFCvzoCgmcf5HPWUEFaHMwLLCWJg@mail.gmail.com>
 <20111216150812.1ab91f03@notabene.brown>
In-Reply-To: <20111216150812.1ab91f03@notabene.brown>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBG4gbg6013269

Hi Neil,

> In the other case where I do let it suspend early (And it never recovers
> without the reset line being toggled) I see:
> 
> [ 2170.100982] mmc_wait_for_cmd 52 -> -110
> [ 2170.105407] mmc_wait_for_cmd 52 -> -110
> [ 2170.110260] mmc_wait_for_cmd 0 -> 0
> [ 2170.115509] mmc_wait_for_cmd 8 -> -110
> [ 2170.119842] mmc_wait_for_cmd 5 -> 0
> [ 2170.123901] mmc_wait_for_cmd 5 -> 0
> [ 2170.127929] mmc_wait_for_cmd 3 -> 0
> [ 2170.131958] mmc_wait_for_cmd 7 -> 0

This works when reset line toggling was applied.

> [ 2170.135986] mmc_wait_for_cmd 52 -> 0
> [ 2170.140136] mmc_wait_for_cmd 52 -> 0
> [ 2170.144226] mmc_wait_for_cmd 52 -> 0
> [ 2170.148376] mmc_wait_for_cmd 52 -> 0
> [ 2170.152465] mmc_wait_for_cmd 52 -> 0
> 
> 
> which is much the same but then one second later:
> 
> [ 2171.166656] mmc_wait_for_cmd 52 -> 0
> [ 2171.170806] mmc_wait_for_cmd 52 -> 0
> [ 2171.175384] mmc_wait_for_cmd 0 -> 0
> [ 2171.180603] mmc_wait_for_cmd 8 -> -110
> [ 2171.185943] mmc_wait_for_cmd 5 -> -110

Here the CMD5 timeout is expected because SD8686 has already been initialized with CMD5,5,3,7.
If you are able to skip re-initialization at this point, like what "powered_resume" does, you will probably get SD8686 continue to run.

Regards,
Bing

> [ 2171.190093] libertas_sdio: probe of mmc1:0001:1 failed with error -16
> 
> 
> So this answers Bing Zhao's question - it was CMD5 that timed out and caused
> the failure.
> 
> If I just get mmc_wait_for_cmd to hide error -110 for cmd 5 it complains
> 
> [   26.420440] mmc1: host doesn't support card's voltages
> 
> so that isn't a simple solution :-)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
