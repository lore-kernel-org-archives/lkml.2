Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2G3TsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:48:17 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:4421
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755089Ab2G3TsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:48:14 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I542M1432I4015Izz1202hzz8275dhz2fh2a8h668h839h93fhd25hf0ah107ah)
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net,1/1] hyperv: Add support for setting MAC from within
 guests
Thread-Topic: [PATCH net,1/1] hyperv: Add support for setting MAC from
 within guests
Thread-Index: AQHNXr4xkC9nKE+X/0yPruu1JeSp7JdB4zqAgAB10dA=
Date: Mon, 30 Jul 2012 19:48:06 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DDF7B24@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1341940762-18307-1-git-send-email-haiyangz@microsoft.com>
 <20120730123927.GA29459@aepfle.de>
In-Reply-To: <20120730123927.GA29459@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6UJmQjS006662



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Monday, July 30, 2012 8:39 AM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; KY Srinivasan; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH net,1/1] hyperv: Add support for setting MAC from
> within guests
> 
> On Tue, Jul 10, Haiyang Zhang wrote:
> 
> > diff --git a/drivers/net/hyperv/rndis_filter.c
> > b/drivers/net/hyperv/rndis_filter.c
> > index 981ebb1..fbf5394 100644
> > --- a/drivers/net/hyperv/rndis_filter.c
> > +++ b/drivers/net/hyperv/rndis_filter.c
> > @@ -47,6 +48,7 @@ struct rndis_request {
> >  	struct hv_page_buffer buf;
> >  	/* FIXME: We assumed a fixed size request here. */
> >  	struct rndis_message request_msg;
> > +	u8 ext[100];
> 
> This array is not referenced in the patch.
> Please add a comment to the code what the purpose of this array is, and why
> its size is 100 bytes.

It's a buffer for the extended info after the RNDIS message. It's referenced based
on the data offset in the RNDIS message. 100 byte size is enough for current needs, 
and should be sufficient for the near future.

I will add a comment to the code.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
