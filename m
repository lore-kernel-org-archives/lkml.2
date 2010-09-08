Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0IHN6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:58:34 -0400
Received: from imr4.ericy.com ([198.24.6.8]:57055 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0IHN6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:58:33 -0400
Date: Wed, 8 Sep 2010 06:56:54 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: Add support for max6695 and max6696 to lm90
 driver
Message-ID: <20100908135654.GA11277@ericsson.com>
References: <1283639675-31714-1-git-send-email-guenter.roeck@ericsson.com>
 <20100906181229.2e25db07@hyperion.delvare>
 <20100908102816.GA10676@ericsson.com>
 <20100908134854.2c60f406@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100908134854.2c60f406@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, Sep 08, 2010 at 07:48:54AM -0400, Jean Delvare wrote:
> On Wed, 8 Sep 2010 03:28:16 -0700, Guenter Roeck wrote:
> > Hi Jean,
> > 
> > On Mon, Sep 06, 2010 at 12:12:29PM -0400, Jean Delvare wrote:
> > > Hi Guenter,
> > > 
> > > On Sat, 4 Sep 2010 15:34:35 -0700, Guenter Roeck wrote:
> > > > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > > > ---
> > > > To apply this patch, the previously submitted lm90 cleanup patch has to be
> > > > applied first.
> > > >
> > > > My main concern with this patch is the chip detection code, specifically if it
> > > > is able to safely distinguish between MAX6680/81 and MAX6695/96.
> > > > Would be great to get some test coverage from a system with one of those chips.
> > > 
> > > Unfortunately I don't have any of these Maxim chips at hand. I have an
> > > ADM1032 but it won't offer much coverage obviously. And I have dumps of
> > > Maxim chips, but the real chips behave differently, so it's of little
> > > help.
> > > 
> > Do you by any chance have register dumps of max6657/58/59 ?
> 
> Yes I do. I have dumps of max6658 and max6659 chips, I'm attaching
> them. Please keep in mind that registers are read sequentially, in
> order, and this matters because these chips return the last read value
> whenever you access a nonexistent register. This even holds for
> registers with fewer than 8 bits, e.g. config1.
> 
> > max6659 also supports a 3rd upper limit. Turns out it is convenient to add support
> > for this limit first before adding support for max6696. To do that, I'll need
> > to be able to distinguish between max6657/58 and max6659. My thought is to check
> > for the address and if register 0x16 exists.
> > 
> > Also, do you happen to remember why address 0x4e for max6659 is not supported by the driver ?
> > The code only says that it isn't supported, and it does not detect it, but there
> > is not reason. sensors-detect does detect it at address 0x4e.
> 
> I think the reason is historical. As we never had a report of anyone
> with a MAX6659 chip at 0x4e, and detection for this device is weak, and
> the driver didn't support any other device at this address, it seemed
> more reasonable to not scan the address at all. Now that the driver
> supports more devices at this address and thus scans it anyway, I have
> no objection supporting the MAX6659 at 0x4e.
> 
Too bad - registers 0x16 and 0x17 exist on both 6658 and 6659. So the only way to detect 6659 
would be the address (0x4d or 0x4e), and we would mis-detect it on 0x4c. Is that worth it ?

Guenter
