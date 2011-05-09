Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1EIKrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:47:36 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:17014
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab1EIKrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:47:35 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz9371O542M1432N98dKzz1202hzzz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.Kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Date: Mon, 9 May 2011 16:03:41 +0530
Subject: RE: [PATCHv2 -next] MFD: MFD module of DA9052 PMIC driver
Thread-Topic: [PATCHv2 -next] MFD: MFD module of DA9052 PMIC driver
Thread-Index: AcwJoJWBy5+MIWKaTx2pRziFPYwAkAEgNyCg
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BB713DB@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5AFBA@KCINPUNHJCMS01.kpit.com>
 <20110503144441.GS1762@opensource.wolfsonmicro.com>
In-Reply-To: <20110503144441.GS1762@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p49AlmJt024223


> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Tuesday, May 03, 2011 8:15 PM
> To: Ashish Jangam
> Cc: sameo@openedhand.com; linux-kernel@vger.kernel.org; Dajun Chen
> Subject: Re: [PATCHv2 -next] MFD: MFD module of DA9052 PMIC driver
> 
> On Tue, May 03, 2011 at 07:30:54PM +0530, Ashish Jangam wrote:
> 
> > +int da9052_unmask_events(struct da9052 *da9052, unsigned int events)
> > +{
> > +       uint8_t v[4];
> > +
> > +       da9052->events_mask &= ~events;
> > +
> > +       v[0] = (da9052->events_mask & 0xff);
> > +       v[1] = (da9052->events_mask >> 8) & 0xff;
> > +       v[2] = (da9052->events_mask >> 16) & 0xff;
> > +       v[3] = (da9052->events_mask >> 24) & 0xff;
> > +
> > +       return da9052_group_write(da9052, DA9052_IRQ_MASK_A_REG, 4, v);
> > +}
> > +
> > +int da9052_mask_events(struct da9052 *da9052, unsigned int events)
> > +{
> > +       uint8_t v[4];
> > +
> > +       da9052->events_mask |= events;
> > +
> > +       v[0] = (da9052->events_mask & 0xff);
> > +       v[1] = (da9052->events_mask >> 8) & 0xff;
> > +       v[2] = (da9052->events_mask >> 16) & 0xff;
> > +       v[3] = (da9052->events_mask >> 24) & 0xff;
> > +
> > +       return da9052_group_write(da9052, DA9052_IRQ_MASK_A_REG, 4, v);
> > +}
> 
> My previous queries about why this is here and not in the IRQ code still
> stand.
> 
> > +static void da9052_irq_sync_unlock(struct irq_data *data)
> > +{
> > +       struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
> > +       struct da9052_irq_data *irq_data = irq_to_da9052_irq(da9052,
> > +                                               data->irq);
> > +
> > +       da9052_mask_events(da9052, irq_data->event);
> > +       mutex_unlock(&da9052->irq_lock);
> 
> What happens if an event was enabled while the bus was locked?
Event stays in the hardware till it's not explicitly cleared. Hence there won't be any event loss.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
