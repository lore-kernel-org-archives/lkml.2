Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2JJJQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:16:15 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:45358
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329Ab2JJJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:16:07 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441hbe9i1155h)
Subject: Re: [Patch v2 2/7] Regulator: DA9055 Regulator driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <dchen@diasemi.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20121010035622.GH17288@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED38A84E78@KCHJEXMB03.kpit.com>
	 <1349780416.5244.39.camel@dhruva>
	 <20121010035622.GH17288@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Oct 2012 14:57:05 +0530
Message-ID: <1349861225.7957.9.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 12:56 +0900, Mark Brown wrote:
> On Tue, Oct 09, 2012 at 04:30:16PM +0530, Ashish Jangam wrote:
> > On Tue, 2012-10-09 at 15:37 +0530, Mark Brown wrote:
> > > On Mon, Oct 08, 2012 at 07:00:39PM +0530, Ashish Jangam wrote:
> 
> > > > +		/* Set the GPIO I/P pin for controlling the regulator state. */
> > > > +		ret = devm_gpio_request_one(config->dev, gpio, GPIOF_DIR_IN,
> > > > +					    name);
> > > > +		if (ret < 0)
> > > > +			goto err;
> 
> > > We never actually appear to use this GPIO anywhere...  why are we
> > > requesting it?
> 
> > DA9055 regulator changes its state by detecting the rising/failing edge at
> > GPI DA9055. Therefore we just need to set the DA9055 GPIO direction to input.
> 
> Right, so there's several problems here.  One is that this code is very
> obscure - you're really doing pinmux here rather than actually using it
> as a GPIO, a better comment would clarify this.  The other is that
> you're requiring a defined gpio_base in platform data, it would be
> better to allow this to be dynamically assigned as the driver can find
> it's own GPIOs easily enough.
Ok, will modify the comments and instead of taking gpio offset I will
take gpio number from the platform data.


