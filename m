Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1CBR6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:58:09 -0500
Received: from protonic.xs4all.nl ([213.84.116.84]:21094 "EHLO protonic.prtnl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756065Ab1CBR6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:58:07 -0500
Message-ID: <33012.84.56.74.117.1299088565.squirrel@protonic.xs4all.nl>
In-Reply-To: <20110302183143.c52ecc00.sfr@canb.auug.org.au>
References: <20110301145436.b1ae1923.sfr@canb.auug.org.au>
    <20110301093528.00184f93@archvile>
    <20110302183143.c52ecc00.sfr@canb.auug.org.au>
Date: Wed, 2 Mar 2011 18:56:05 +0100 (CET)
Subject: Re: linux-next: manual merge of the mfd tree with the i.MX tree
From: david@protonic.nl
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: "David Jander" <david.jander@protonic.nl>,
        "Samuel Ortiz" <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Andres Salomon" <dilinger@queued.net>,
        "David Jander" <david@protonic.nl>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        Uwe =?iso-8859-1?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi David,
>
> On Tue, 1 Mar 2011 09:35:28 +0100 David Jander <david.jander@protonic.nl>
> wrote:
>>
>> Your fix seems correct, although I fear I am too dumb to understand why
>> commit
>> e84e545d47d26644275a79fe5ebc1797bcb80910 introduces this extra struct
>> nesting.... AFAICS gcc will end up doing the same as without the extra
>> nest.
>
> Thanks.
>
>> Btw, include/linux/mfd/mc13783.h should end up disappearing after you're
>> done
>> merging... I hope so.
>
> That file is still included by several others:
>
> $ git grep -w mfd/mc13783.h
> arch/arm/mach-imx/mach-mx27_3ds.c:#include <linux/mfd/mc13783.h>
> arch/arm/mach-imx/mach-pcm038.c:#include <linux/mfd/mc13783.h>
> arch/arm/mach-mx3/mach-mx31_3ds.c:#include <linux/mfd/mc13783.h>
> arch/arm/mach-mx3/mach-mx31lilly.c:#include <linux/mfd/mc13783.h>
> arch/arm/mach-mx3/mach-mx31lite.c:#include <linux/mfd/mc13783.h>
> arch/arm/mach-mx3/mach-mx31moboard.c:#include <linux/mfd/mc13783.h>
> drivers/hwmon/mc13783-adc.c:#include <linux/mfd/mc13783.h>
> drivers/input/touchscreen/mc13783_ts.c:#include <linux/mfd/mc13783.h>
> drivers/leds/leds-mc13783.c:#include <linux/mfd/mc13783.h>
> drivers/mfd/mc13xxx-core.c:#include <linux/mfd/mc13783.h>
> drivers/regulator/mc13783-regulator.c:#include <linux/mfd/mc13783.h>

These should all be either removed or changed to mc13xxx.h by subsequent
patches.
Sascha, where is the rest?
AFAICR, I already fixed all of these...

Best Regards,

-- 
David Jander


