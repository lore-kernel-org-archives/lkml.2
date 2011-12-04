Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1LDLuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 06:50:12 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:49787
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262Ab1LDLuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 06:50:08 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zz9371K542M1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: RE: [PATCH 01/11] MFD: DA9052 MFD core module v8
Thread-Topic: [PATCH 01/11] MFD: DA9052 MFD core module v8
Thread-Index: AQHMsPskQLUp8qw0vkG1lzNupT16P5XLkHlQ
Date: Sun, 4 Dec 2011 11:50:02 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED1F9CFD44@KCHJEXMB01.kpit.com>
References: <1321607994.10344.20.camel@dhruva>
 <20111124120541.GG8470@opensource.wolfsonmicro.com>
 <C3AE124F08223B42BC95AEB82F0F6CED1F9CFD03@KCHJEXMB01.kpit.com>
 <20111202140304.GT8245@opensource.wolfsonmicro.com>
In-Reply-To: <20111202140304.GT8245@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [1.22.22.104]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB4BoUUV001560


> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Friday, December 02, 2011 7:33 PM
> To: Ashish Jangam
> Cc: arnd@arndb.de; sameo@openedhand.com; linux-kernel@vger.kernel.org;
> Dajun; linaro-dev@lists.linaro.org
> Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v8
> 
> On Fri, Dec 02, 2011 at 01:57:49PM +0000, Ashish Jangam wrote:
> > > On Fri, Nov 18, 2011 at 02:49:54PM +0530, Ashish Jangam wrote:
> 
> > > > + * Interrupt controller support for Dilaog DA9052 PMICs.
> 
> > > This looks very much like it could be replaced with regmap-irq.  The
> > > code would be slightly less efficient due to the support for sparse
> > > interrupt registers but it'd be less code.
> 
> > regmap-irq has a opaque struct regmap_irq_chip_data which has a member
> > irq_base and this is required for non-primary irqs registration
> > and also the clean-up function regmap_del_irq_chip() requires it.
> > So as of now I will keep the current irq implementation as it is.
> 
> I'm not sure how this is relevant to my above comment?  The struct is of
> course opaque since it is only used by the implementation.
No issues on that but it has got irq_base as its member which gets initialize in the
function regmap_add_irq_chip() and since this member value is not available
to the user how can the mfd dependent modules like touch, battery etc can register
for interrupt because during irq registration we add irq_base to the irq nmber for
e.g. irq_base + battery_irq  



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
