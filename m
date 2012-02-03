Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab2BCDfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 22:35:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12825 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab2BCDfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 22:35:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 02 Feb 2012 19:35:33 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Voss, Nikolaus" <N.Voss@weinmann.de>,
        =?utf-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
CC: "'linux-mtd@lists.infradead.org'" <linux-mtd@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Fri, 3 Feb 2012 09:05:29 +0530
Subject: RE: [PATCH] mtd: atmel_nand: fix access to 16 bit NAND devices
Thread-Topic: [PATCH] mtd: atmel_nand: fix access to 16 bit NAND devices
Thread-Index: Aczhou94g2X+EODkR2yEqVGrbCEVswAgKUgQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD0B99114@BGMAIL02.nvidia.com>
References: <201201251217.q0PCHmRe027024@gatekeeper.vosshq.de>
	 <1327670996.26648.43.camel@sauron.fi.intel.com>
	 <EF2E73589CA71846A15D0B2CDF79505D08AD3E5453@wm021.weinmann.com>
	 <4F265B7E.6060806@atmel.com>
 <1328184370.28171.175.camel@sauron.fi.intel.com>
In-Reply-To: <1328184370.28171.175.camel@sauron.fi.intel.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q133Zsfk000512

I see a problem with atmel_read_buf16 & atmel_write_buf16 functions.
As they are calling __raw_readsw & __raw_writesw respectively, which 
would cause panic in cases of 16 bit unaligned buffers.
However, the buf passed to these functions is of type u8* from 
atmel_read_buf & atmel_write_buf functions.

[Venu] 
> -	/* if no DMA operation possible, use PIO */
> -	memcpy_fromio(buf, chip->IO_ADDR_R, len);
> +	if (host->board->bus_width_16)
> +		atmel_read_buf16(mtd, buf, len);

> +	else
> +		atmel_read_buf8(mtd, buf, len);
>  }
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
