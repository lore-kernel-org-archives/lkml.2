Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab2IML5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:57:16 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:34726
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757744Ab2IML5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:57:14 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1102I1432Id6f1izz1202h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdhbe9i1155h)
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: Add DA9055 codec driver
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20120912025709.GD9162@opensource.wolfsonmicro.com>
References: <1347375823.12329.14.camel@matrix>
	 <20120912025709.GD9162@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Sep 2012 17:38:36 +0530
Message-ID: <1347538116.16763.6.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 10:57 +0800, Mark Brown wrote:
> 
> > +	aif_ctrl |= (DA9055_AIF_OE | DA9055_AIF_EN);
> 
> DAPM.

Here the trouble in making it DAPM based is that there is no separate
control for AIF input and output. It is confirmed that AIF_EN is the
master control bit, which enables both output as well as input. The AIF
_OE bit is redundant. If we use the same control bit(i.e AIF_EN) for
both DAPM_AIF_IN and DAPM_AIF_OUT, there will be obvious side effects.
Is there any other way to take care of this? Or should we leave it
outside DAPM?


