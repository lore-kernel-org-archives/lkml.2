Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773Ab1JGKUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:20:42 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:39013
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264Ab1JGKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:20:41 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz9371Kc89bh542M1432N98dKzz1202hzzz32i2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: RE: [Patch 5/11] Regulator: DA9052 regulator support v3
Thread-Topic: [Patch 5/11] Regulator: DA9052 regulator support v3
Thread-Index: AQHMhNLV1ovWsZHrCEyqURGZ5/fv95VwqbCQ
Date: Fri, 7 Oct 2011 10:20:33 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED021908@KCHJEXMB01.kpit.com>
References: <1309948610.4168.12.camel@L-0532.kpit.com>
 <4E8EC517.2050006@linaro.org>
In-Reply-To: <4E8EC517.2050006@linaro.org>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.38.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p97AKq9d006831

> -----Original Message-----
> From: Ying-Chun Liu (PaulLiu) [mailto:paul.liu@linaro.org]
> Sent: Friday, October 07, 2011 2:54 PM
> To: Ashish Jangam
> Cc: Mark Brown; Dajun; linaro-dev@lists.linaro.org; linux-
> kernel@vger.kernel.org; lrg@slimlogic.co.uk
> Subject: Re: [Patch 5/11] Regulator: DA9052 regulator support v3
> 
> (2011å¹´07æœˆ06æ—¥ 18:36), ashishj3 wrote:
> > +static int __devinit da9052_regulator_probe(struct platform_device *pdev)
> > +{
> > +	struct da9052_regulator *regulator;
> > +	struct da9052 *da9052;
> > +	struct da9052_pdata *pdata;
> > +	int ret;
> > +
> > +	regulator = kzalloc(sizeof(struct da9052_regulator), GFP_KERNEL);
> > +	if (!regulator)
> > +		return -ENOMEM;
> > +
> > +	da9052 = dev_get_drvdata(pdev->dev.parent);
> > +	pdata = da9052->dev->platform_data;
> > +
> > +	regulator->info = find_regulator_info(pdev->id);
> > +	if (regulator->info == NULL) {
> > +		dev_err(&pdev->dev, "invalid regulator ID specified\n");
> > +		ret = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	regulator->rdev = regulator_register(&regulator->info->reg_desc,
> > +					     &pdev->dev,
> > +					     pdata->regulators[pdev->id],
> > +					     regulator);
> > +	if (IS_ERR(regulator->rdev)) {
> > +		dev_err(&pdev->dev, "failed to register regulator %s\n",
> > +			regulator->info->reg_desc.name);
> > +		ret = PTR_ERR(regulator->rdev);
> > +		goto err;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, regulator);
> > +
> > +	return 0;
> > +err:
> > +	kfree(regulator);
> > +	return ret;
> > +}
> 
> Hi Ashish,
> 
> It seems to me that in this function, regulator->da9052 isn't initialized.
>
Today I'm going to post regulator patch for DA9052 and DA9053 that has got fixes for this and few more bugs.
This patch is thoroughly tested for DA9052 and DA9053. 
> Regards,
> Paul



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
