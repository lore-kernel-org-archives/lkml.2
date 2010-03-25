Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab0CYJ2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:28:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46855 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750903Ab0CYJ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:28:06 -0400
Date: Thu, 25 Mar 2010 09:28:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Linux I2C <linux-i2c@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: Fix bus-level power management callbacks
Message-ID: <20100325092802.GA27729@rakim.wolfsonmicro.main>
References: <201003132204.30905.rjw@sisk.pl>
 <201003192344.09000.rjw@sisk.pl>
 <20100325095720.0b115056@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325095720.0b115056@hyperion.delvare>
X-Cookie: Jenkinson's Law:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 09:57:20AM +0100, Jean Delvare wrote:

> Mark, you contributed the initial runtime PM support for the i2c
> subsystem, I thought you would have comments on Rafael's
> reimplementation?

Yeah, see below...

> >  drivers/i2c/i2c-core.c     |  168 ++++++++++++++++++++++++++-------------------
> >  include/linux/pm_runtime.h |    7 +

> I am a little surprised to see changes to a generic header file here,
> how is the i2c subsystem so special that we have needs other subsystems
> did not?

Very few subsystems actually support runtime PM thus far - I think it's
more the case that I2C is an early user than anything else.

> Apart from the above, the code looks sane to me, but then again I don't
> know a thing about power management. I'll keep this patch in my i2c
> tree, scheduled for merge in 2.6.35. If there are any updates, please
> send them over, either as a new patch or as incremental changes which I
> will merge myself.

I'm in a similar position - the code looks fine except I'm not 100% sure
I follow all the possible ifdefs and I've never actually used hibernate
(s2disk isn't supported on ARM) but for what it's worth:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
