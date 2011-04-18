Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1DRIVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:21:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56581 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1DRIVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:21:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH V14 3/4] ptp: Added a clock driver for the IXP46x.
Date: Mon, 18 Apr 2011 10:21:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
References: <cover.1303107532.git.richard.cochran@omicron.at> <201104180856.04186.arnd@arndb.de> <20110418080606.GA3809@riccoc20.at.omicron.at>
In-Reply-To: <20110418080606.GA3809@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104181021.01279.arnd@arndb.de>
X-Provags-ID: V02:K0:ncCnTVCR72hkmcjCvZdfAmP/LD2IEb3UQEzJ1O9RzwE
 +Aoz1jDADJr9sjHneotsP8BzUKKwI8mkPWOKkL3JoB8gP1cuSa
 uv2pk+VW/HrYGA84VVeGEGm8G8WPL6lQivX0IIqmhn7pT8D3Ad
 E2lPTb5WIar0kGoy4yoRvoq2cTbht1b9j0Xdo9HIWmP5RDNPR0
 33i2qR5hEZsSA8ZIxvgVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Richard Cochran wrote:
> On Mon, Apr 18, 2011 at 08:56:03AM +0200, Arnd Bergmann wrote:
> > On Monday 18 April 2011, Richard Cochran wrote:
> > > +
> > > +       lo = __raw_readl(&regs->channel[ch].src_uuid_lo);
> > > +       hi = __raw_readl(&regs->channel[ch].src_uuid_hi);
> > > +
> > 
> > I guess you should use readl(), not __raw_readl() here. The __raw_* functions
> > are not meant for device drivers.
> 
> Krzysztof had a different opinion about this.
> 
>     https://lkml.org/lkml/2011/1/8/67
> 
> Anyway, it is his driver, and I just followed what he does elsewhere
> in the driver. It make sense to me to keep the driver consistent.
> Maybe we should make the change throughout?

It would certainly be useful to fix it up. I now realized that this driver
supports both big-endian and little-endian configurations, so just using
readl() is certainly broken.
There should probably be an ixp specific version of the safe I/O accessors
to deal with it on all on-chip peripherals in a safe way.

	Arnd
