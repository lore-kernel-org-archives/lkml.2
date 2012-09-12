Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2ILNlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:41:14 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:7910
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab2ILNlL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:41:11 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.177;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC02.kpit.com;RD:59.163.77.177.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -10
X-BigFish: VPS-10(zz98dI9371I936eI1b0bI542M1432Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh1155h)
From: "Ashish P. Chavan" <Ashish.Chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [alsa-devel] [PATCH] ASoC: codecs: Add DA9055 codec driver
Thread-Topic: [alsa-devel] [PATCH] ASoC: codecs: Add DA9055 codec driver
Thread-Index: AQHNkJJXjYGL0ryTjE2i7+7aamj50JeGqQlqgAANv0A=
Date: Wed, 12 Sep 2012 13:40:31 +0000
Message-ID: <E3DB41DBD579A349B4BC7C95EADB061645B8BAD0@KCHJEXMB03.kpit.com>
References: <1347375823.12329.14.camel@matrix>
 <20120912025709.GD9162@opensource.wolfsonmicro.com>
 <1347454578.23366.305.camel@matrix>
 <20120912124932.GC19055@opensource.wolfsonmicro.com>
In-Reply-To: <20120912124932.GC19055@opensource.wolfsonmicro.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.20.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI.

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: Wednesday, September 12, 2012 6:20 PM
To: Ashish P. Chavan
Cc: lrg; alsa-devel; linux-kernel; David Dajun Chen
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: Add DA9055 codec driver

On Wed, Sep 12, 2012 at 06:26:18PM +0530, Ashish Chavan wrote:
> On Wed, 2012-09-12 at 10:57 +0800, Mark Brown wrote:

> > Why is any of this being exposed to userspace?  If this should be 
> > configured I'd expect it to be static platform data, not something 
> > that gets changed at runtime.

> These parameters are exposed considering the fact that DMIC itself is 
> not part of the codec. Codec only provides DMIC interface using which 
> an external DMIC can be attached. These parameters depend on the 
> actual DMIC hardware and hence kept configurable to allow runtime plug 
> in of any DMIC hardware. Doesn't it make sense to keep them runtime 
> configurable?

No.  The only realistic way to attach a new DMIC to a board is to solder it down, that's not something people are going to do while the system is actve.  It's something that's fixed at PCB design time.

> > > +	/* In slave mode, there is only one set of divisors */
> > > +	if (!da9055->master)
> > > +		fout = 2822400;

> > Should check the user supplied this value

> Can you explain which value / user supplied value you are referring to?
> It is not quite clear to me.

The specified output frequency, you just totally ignore it.

> For other things like input mixers, Headphone and Lineouts, DAPM is 
> already used to control power specific bits. The confusion is because 
> there are two separate control bits for these blocks. One bit is for 
> "Enabling" that block and other is for "Enabling Amplifier" of that 
> block.
> e.g for headphone, one bit is for "output enable" while other is for 
> "output amplifier enable".

So document this.


