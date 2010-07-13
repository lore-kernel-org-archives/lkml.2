Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0GMO4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:56:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47961 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752510Ab0GMO4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:56:47 -0400
Date: Tue, 13 Jul 2010 15:56:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific
 data
Message-ID: <20100713145645.GA24626@rakim.wolfsonmicro.main>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
 <20100713141828.GB24260@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B1810E7E88D@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33A307AF30D7BF4F811B1568FE7A9B1810E7E88D@EXDCVYMBSTM006.EQ1STM.local>
X-Cookie: Goodbye, cool world.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 04:41:34PM +0200, Sundar R IYER wrote:
> >> +static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
> >> +	{ .dev = NULL, .supply = "vaux1", },
> >> +};

> >All these supplies with NULL devices are bogus, supplies are in terms of
> >the device being supplied not the labels on the board.  If you've got a
> >supply with no device and the name of the supply on either the regulator
> >or the board you're most likely doing it wrong.  The only exception is
> >for supplies used in cpufreq since we don't have a struct device we can
> >use there.

> I had these supplies as NULL, so that later on, when we add devices for our platform, 
> each developer can edit this file to hook up his own device. The reason I wanted this
> file in the patch set was to include the machine constraints for the regulators on AB8500.

I'm pretty sure that people will be able to figure out how to add a
consumer list by themselves when they need it, and the lists you're
currently including are actively harmful in that they are encouraging
people to hard code board specific supply names or start passing supply
names around as platform data.
