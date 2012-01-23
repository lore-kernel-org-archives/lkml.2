Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2AWNiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:38:51 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33351 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2AWNiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:38:50 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zz9371I936eK542M1432N98dKzz1202hzz8275dhz2dhc1bhc31hc1ah2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 13,
Subject: Re: mfd regmap irq to handle some cases
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1FDCFCAF@KCHJEXMB01.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDCFCAF@KCHJEXMB01.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Jan 2012 19:03:31 +0530
Message-ID: <1327325611.23929.15.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 19:02 +0530, Ashish Jangam wrote:
> 
> > -----Original Message-----
> > From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> > Sent: Monday, January 23, 2012 5:22 PM
> > To: Ashish Jangam
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: mfd regmap irq to handle some cases
> > 
> > On Mon, Jan 23, 2012 at 02:17:03PM +0530, Ashish Jangam wrote:
> > 
> > Please fix your mailer to word wrap within 80 columns.  I've reflowed
> > your text for legibility.
> > 
> > > For a quick fix in regmap irq we may tempt to defer event
> > > clarification after processing of event but there is a problem in this
> > 
> > That's not going to work in general, it means there's a race between
> > handling the interrupt and acknowledging the interrupt which leads to
> > interrupts being dropped if you get a new interrupt before the ack has
> > been written back.
I'm aware of this but added to this there is also another issue specific
to DA9052 that was highlighted.
> > 
> > > approach for some variants of DA9052 and DA9053 when event is cleared
> > > a spurious interrupt gets generated therefore in earlier release of
> > > DA9052/53 MFD module a delay was added. Therefore we need to think on
> > > how to handle such cases in regmap irq.
> > 
> > What are the consequences of the spurious interrupt?
> 
There will processing of false events which is undesirable. 


