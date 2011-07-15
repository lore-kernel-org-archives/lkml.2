Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965438Ab1GOLAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 07:00:34 -0400
Received: from webmail-out1.one.com ([91.198.169.16]:55296 "EHLO
	webmail-out1.b-one.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964787Ab1GOLAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 07:00:32 -0400
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
From: "Eric Andersson" <eric.andersson@unixphere.com>
To: "Jonathan Cameron" <jic23@cam.ac.uk>
CC: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        "Albert Zhang" <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v3 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Date: Fri, 15 Jul 2011 13:00:30 +0200
X-Mailer: One.com webmail
X-Originating-Ip: 213.115.10.98
In-Reply-To: <4E1FFD3E.7090103@cam.ac.uk>
References: <20110715082316.5A4792C03C24@bmail01.one.com>
 <4E1FFD3E.7090103@cam.ac.uk>
Message-Id: <20110715110030.9462398E4682E@bmail03.one.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your input Jonathan!

> >>> +		values represent the range given as +/- G.
> >>> +		Possible values are: 2, 4, 8.
> >>> +
> >>> +		Reading: returns the current acceleration range.
> >>> +
> >>> +		Writing: sets a new acceleration range.
> >>
> >> Same comment as last time - these values are not discoverable so it
> >> should set the nearest bigger range.
> > 
> > And same answer as last time - The values can be retreived by doing
> > a:
> > cat range. This whole idea comes from a review comment that Jonathan
> > Cameron
> > gave on your bma023 driver [1].
> Needs documenting. Right now there is no mention of that here.

True. I'll add a comment on how to get the valid values in v4.

> > If we could agree on how these values should be represented I will
> > be glad
> > to fix it! Dmitry, any preferences?
> 
> > 
> > [1] http://www.spinics.net/lists/linux-input/msg14271.html
> > 
> >>> +	for (i = 0, ret = 0; i < ARRAY_SIZE(bw_val); i++)
> >>> +		ret += sprintf(buf + ret,
> >>> +			(bw_val[i].reg == bw) ? "[%d] " : "%d ",
> >>> +			bw_val[i].value);
> >>
> >> sysfs nodes should really be single values
> > 
> > Once again it's a previous comment from Jonathan [1]. Please specify
> > how
> > you want this and I'll fix it.
> Yes in general to the single value, but this is a pretty common syntax
> for
> choosing one of a set.  Got to indicate it somehow and it's either
> this or
> a list of available ones in a separate attribute.  There was an LWN
> article
> on this a while back that lays out the options very clearly
> http://lwn.net/Articles/378884/

An extra attribute does sound a bit over-kill to me. Would it be acceptable to
keep it the way it is?

> >>> +static const struct i2c_device_id bma150_id[] = {
> >>> +	{ "bma150", 0 },
> >>> +	{ "smb380", 0 },
> >>
> >> bma023 ?
> > 
> > As mentioned earlier bma023 is not an official product name from
> > Bosch Sensortec. Hence,
> > there will be no datasheet available or references from Bosch
> > Sensortec. IMHO it would be
> > confusing to add it.
> Just ignore the marketing and add it anyway :)

You are probably right. I'll add it.

> >> It also doesn't expose the thresholds or support interrupts which
> >> the
> >> one I posted did.
> > 
> > We were told by Bosch S that the interrupt is triggered every 333 us
> > (data ready) which would
> > pretty much flood the irq handler.
> Somewhat quick, but maybe still worth having...  Just use a one shot
> threaded interrupt and it
> will at least run safely even if it isn't keeping up with all of them.
> Alan, do you have a device
> that has frequency control on chip? (very unusual not to see this on
> an accelerometer).

Ok, I will add irq handling for v4. It will be threshold triggered, meaning I will also add the
threshold parameters from bma023. If no .irq is given it will use polldev. Does that work for you Alan?

Regarding the sysfs paramters - how about removing them and use platform data only?

Best regards,
 Eric

http://www.unixphere.com
