Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2BAIfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:35:06 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:19581
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949Ab2BAIfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:35:04 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [PATCH 07/07] ONKEY: OnKey module for DA9052/53 PMIC v1
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA3ED@KCHJEXMB02.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA3ED@KCHJEXMB02.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 1 Feb 2012 13:58:55 +0530
Message-ID: <1328084935.19234.36.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 13:30 +0530, Ashish Jangam wrote:
> On Tue, Jan 17, 2012 at 06:59:11PM +0530, Ashish Jangam wrote:
> 
> > +	ret = da9052_reg_read(onkey->da9052, DA9052_EVENT_B_REG);
> > +	if (ret < 0) {
> > +		dev_err(onkey->da9052->dev,
> > +			"da9052_onkey_report_event da9052_reg_read error %d\n",
> > +			ret);
> > +		ret = 1;
> > +	} else {
> > +		ret = ret & DA9052_EVENTB_ENONKEY;
> > +		input_report_key(onkey->input, KEY_POWER, ret);
> > +		input_sync(onkey->input);
> > +	}
> > +
> > +	if (ret)
> > +		schedule_delayed_work(&onkey->work, msecs_to_jiffies(50));
> 
> Why not just schedule the work directly?  The use of ret took a bit of
> thinking about to follow.
schedule_dealyed_work simulates the release of the onkey button since event for release
is not generated and ret & DA9052_EVENTB_ENONKEY is used to determine the release
of the onkey button.
> > +	error = request_threaded_irq(onkey->da9052->irq_base + onkey->irq, NULL,
> > +				     da9052_onkey_irq,
> 
> This looks buggy, the resource should have the IRQ you need directly in
> it.  The MFD core can do this for the chip core driver when it registers
> children.
> 
As irq_base may get determined at runtime this will require modification to the
defined resource struct for each mfd child in the device init function of the mfd core.
Not sure if this is fine.


