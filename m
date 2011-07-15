Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965214Ab1GOIXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:23:20 -0400
Received: from webmail-out1.one.com ([91.198.169.16]:27720 "EHLO
	webmail-out1.b-one.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965123Ab1GOIXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 04:23:18 -0400
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
From: "Eric Andersson" <eric.andersson@unixphere.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
CC: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com,
        "Albert Zhang" <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v3 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Date: Fri, 15 Jul 2011 10:23:16 +0200
X-Mailer: One.com webmail
X-Originating-Ip: 213.115.10.98
In-Reply-To: <20110714234030.30d6b455@lxorguk.ukuu.org.uk>
References: <1310680572-27410-2-git-send-email-eric.andersson@unixphere.com>
 <20110714234030.30d6b455@lxorguk.ukuu.org.uk>
Message-Id: <20110715082316.5A4792C03C24@bmail01.one.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		values represent the range given as +/- G.
> > +		Possible values are: 2, 4, 8.
> > +
> > +		Reading: returns the current acceleration range.
> > +
> > +		Writing: sets a new acceleration range.
> 
> Same comment as last time - these values are not discoverable so it
> should set the nearest bigger range.

And same answer as last time - The values can be retreived by doing a:
cat range. This whole idea comes from a review comment that Jonathan Cameron
gave on your bma023 driver [1].
If we could agree on how these values should be represented I will be glad
to fix it! Dmitry, any preferences?

[1] http://www.spinics.net/lists/linux-input/msg14271.html

> > +	for (i = 0, ret = 0; i < ARRAY_SIZE(bw_val); i++)
> > +		ret += sprintf(buf + ret,
> > +			(bw_val[i].reg == bw) ? "[%d] " : "%d ",
> > +			bw_val[i].value);
> 
> sysfs nodes should really be single values

Once again it's a previous comment from Jonathan [1]. Please specify how
you want this and I'll fix it.

> > +static const struct i2c_device_id bma150_id[] = {
> > +	{ "bma150", 0 },
> > +	{ "smb380", 0 },
> 
> bma023 ?

As mentioned earlier bma023 is not an official product name from Bosch Sensortec. Hence,
there will be no datasheet available or references from Bosch Sensortec. IMHO it would be
confusing to add it.
 
> It also doesn't expose the thresholds or support interrupts which the
> one I posted did.

We were told by Bosch S that the interrupt is triggered every 333 us (data ready) which would
pretty much flood the irq handler.
However, if this is stopping the patch we can add it. Would it be acceptable to have a driver
that supports both a polling and irq driven setup, e.g. by checking if the .irq is non zero?

> So while its better it still seems incomplete - its certainly nowhere
> near where it can replace the one I posted months ago and doesn't seem
> to
> be making any headway.
> 
> Dmitry shall I repost the intel one - at this point I think it would
> be a
> better starting point as it supports more features, interrupts and the
> like although it's not perfect either.

My hope is that we can sort out the differences before I post v4. Dmitry, if you have time
could you please give an objective review of the patch?

Best regards,
 Eric

http://www.unixphere.com
