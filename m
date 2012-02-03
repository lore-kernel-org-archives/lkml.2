Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab2BCNa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:30:29 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:22043
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756088Ab2BCNa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:30:27 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [PATCH 07/07] ONKEY: OnKey module for DA9052/53 PMIC v1
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA575@KCHJEXMB02.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA575@KCHJEXMB02.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 3 Feb 2012 18:54:06 +0530
Message-ID: <1328275446.19234.127.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 17:28 +0530, Ashish Jangam wrote:
> 
> On Wed, Feb 01, 2012 at 01:58:55PM +0530, Ashish Jangam wrote:
> > On Wed, 2012-02-01 at 13:30 +0530, Ashish Jangam wrote:
> 
> > > > +	ret = da9052_reg_read(onkey->da9052, DA9052_EVENT_B_REG);
> > > > +	if (ret < 0) {
> > > > +		dev_err(onkey->da9052->dev,
> > > > +			"da9052_onkey_report_event da9052_reg_read error %d\n",
> > > > +			ret);
> > > > +		ret = 1;
> > > > +	} else {
> > > > +		ret = ret & DA9052_EVENTB_ENONKEY;
> > > > +		input_report_key(onkey->input, KEY_POWER, ret);
> > > > +		input_sync(onkey->input);
> > > > +	}
> 
> > > > +	if (ret)
> > > > +		schedule_delayed_work(&onkey->work, msecs_to_jiffies(50));
> 
> > > Why not just schedule the work directly?  The use of ret took a bit 
> > > of thinking about to follow.
> 
> > schedule_dealyed_work simulates the release of the onkey button since 
> > event for release is not generated and ret & DA9052_EVENTB_ENONKEY is 
> > used to determine the release
> 
> That doesn't seem to address the concern.  You're setting ret in exactly one place
> and scheduling the work in exactly one place, why are these two things split?
schedule_delayed_work() is conditional because it should get invoke when onkey button is 
pressed and not when released. For this reason onkey event is first queried and work is
scheduled only when event is present. Now when work is scheduled, onkey event gets
queried and in absence of the onkey event work will not get schedule again. By this logic I'm able
to simulated the release of the onkey button.


