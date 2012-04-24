Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2DXNtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:49:21 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:43254
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154Ab2DXNtS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:49:18 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h944hd25hbe9i)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: RE: [Patch] Touch: DA9052/53 touch screen driver v2
Thread-Topic: [Patch] Touch: DA9052/53 touch screen driver v2
Thread-Index: AQHNH4lk4PQTk97+3kOpYk3/p0Sjd5aqAgtQ
Date: Tue, 24 Apr 2012 13:48:43 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED2D5624CA@KCHJEXMB02.kpit.com>
References: <1334924925.3752.14.camel@dhruva>
 <20120421063855.GA2360@core.coreip.homeip.net>
In-Reply-To: <20120421063855.GA2360@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.38.22]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Apr 20, 2012 at 05:58:45PM +0530, Ashish Jangam wrote:
> > +static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
> > +{
> > +	struct da9052_tsi *tsi = data;
> > +
> > +	if (!tsi->stopped) {
> > +		/* Mask PEN_DOWN event and unmask TSI_READY event */
> > +		disable_irq_nosync(tsi->da9052->irq_base + tsi->irq_pendwn);
> > +		enable_irq(tsi->da9052->irq_base + tsi->irq_datardy);
> 
> Why did you switch to using irq_base here? da9052_onkey driver does not
> do that, should it?
On i.mx53 loco board irq_base was required so to keep driver working across
boards this was introduced. Need to fix this in onkey driver. 
> 
> Thanks.
> 
> --
> Dmitry


