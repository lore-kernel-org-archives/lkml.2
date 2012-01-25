Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab2AYEa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 23:30:27 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:41888 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2AYEa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 23:30:26 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zz9371I936eK1432N98dKzz1202hzz8275dhz2dhc1bhc31hc1ah2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: mfd regmap irq to handle some cases
Thread-Topic: mfd regmap irq to handle some cases
Thread-Index: AQHM2eIHcWS+3/sK4UalWoOv01AmyZYce8yV
Date: Wed, 25 Jan 2012 04:28:29 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED1FDCFDBC@KCHJEXMB01.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDCFCAF@KCHJEXMB01.kpit.com>
 <1327325611.23929.15.camel@dhruva>,<20120123151830.GA21857@opensource.wolfsonmicro.com>
In-Reply-To: <20120123151830.GA21857@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.199.208.129]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Mark Brown [broonie@opensource.wolfsonmicro.com]
Sent: Monday, January 23, 2012 8:48 PM
To: Ashish Jangam
Cc: linux-kernel@vger.kernel.org
Subject: Re: mfd regmap irq to handle some cases

On Mon, Jan 23, 2012 at 07:03:31PM +0530, Ashish Jangam wrote:
> On Mon, 2012-01-23 at 19:02 +0530, Ashish Jangam wrote:

> > > > approach for some variants of DA9052 and DA9053 when event is cleared
> > > > a spurious interrupt gets generated therefore in earlier release of
> > > > DA9052/53 MFD module a delay was added. Therefore we need to think on
> > > > how to handle such cases in regmap irq.

> > > What are the consequences of the spurious interrupt?

> There will processing of false events which is undesirable.

But what actually happens?  RTC interrupts aren't going to be high
volume, if we get the odd spurious interrupt and handle it gracefully
I'm not sure we really care.

( As I'm traveling so please ignore the mail format)
spurious interrupt we get on clearing event and event can be from any
mfd children. But since now, deferring event clear is not the approach
we can ignore about the spurious interrupt.
Now looking at the old issue of determining the RTC type (periodic or tick)
on event clearing this info (RTC type) gets lost for the register since in regmap_irq
we first clear and then process the event.


