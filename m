Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2DQG3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:29:21 -0400
Received: from portal.weinmann.de ([62.8.140.122]:54196 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2DQG3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:29:19 -0400
X-Greylist: delayed 983 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2012 02:29:19 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Adrian Yanes'" <adrian.yanes@aalto.fi>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>
CC: "'konsta.holtta@aalto.fi'" <konsta.holtta@aalto.fi>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'Hubert Feurstein'" <h.feurstein@gmail.com>,
        "'Douglas Gilbert'" <dgilbert@interlog.com>
Date: Tue, 17 Apr 2012 08:12:30 +0200
Subject: RE: About AT91: replace broken TWI driver i2c-at91.c
Thread-Topic: About AT91: replace broken TWI driver i2c-at91.c
Thread-Index: Ac0b7xZJpptEcvYGRN6pFdj8j8ylOQAa9lhQ
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D0905D5A5FB@wm021.weinmann.com>
References: <4F8C4A8B.2060005@aalto.fi>
In-Reply-To: <4F8C4A8B.2060005@aalto.fi>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3H6TUNV008210

Hi Adrian,

Adrian Yanes wrote on 2012-04-16:
> Changing the value to 400000 gives as ~356kHz rate instead of 400kHz,
> maybe it is due to our processor/board, however, checking the specs of
> the at91rm9200 (page 405) we found that the CLVID and the CHDIV are
> calculated as follow:
> 
> T_low = (( CLDIV x 2^CKDIV) +3) + T_mck
> T_high = (( CHDIV x 2^CKDIV) +3) + T_mck
> 
> which differs of the method suggested in the patch:
> 
> const int div = DIV_ROUND_UP(clk_get_rate(dev->clk), 2 * twi_clk) - 2;

G45 spec is slightly different: T_low = (CLDIV x 2^CKDIV + 4) x T_mck
With
twi_clk := 1 / (T_low + T_high) = 1 / (2 * T_low)
and
div := CLKDIV x 2^CKDIV = MCK / (2 * twi_clk) - 4
the above line should be
const int div = DIV_ROUND_UP(clk_get_rate(dev->clk), 2 * twi_clk) - 4;
for G45 and
const int div = DIV_ROUND_UP(clk_get_rate(dev->clk), 2 * twi_clk) - 3;
for RM9200, right?

I'll repost the driver with the above fix and Hubert's fix.

> Finally, did you consider the possibility to add module_param() to
> handle the TWI_CLK_HZ as a module parameter rather than hardcode the
> value? it will help to those users that want to run the bus to different
> frequencies.

No, but feel free to submit a patch ;-).

Niko

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
