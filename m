Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab1FATf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:35:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301Ab1FATfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:35:23 -0400
Date: Wed, 1 Jun 2011 21:35:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Andrew Chew <AChew@nvidia.com>
cc: "mchehab@redhat.com" <mchehab@redhat.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5 v2] [media] ov9740: Remove hardcoded resolution regs
In-Reply-To: <643E69AA4436674C8F39DCC2C05F76382A75BF37C3@HQMAIL03.nvidia.com>
Message-ID: <Pine.LNX.4.64.1106012128080.29934@axis700.grange>
References: <1306368272-28279-1-git-send-email-achew@nvidia.com>
 <1306368272-28279-4-git-send-email-achew@nvidia.com>
 <Pine.LNX.4.64.1105291221450.18788@axis700.grange>
 <643E69AA4436674C8F39DCC2C05F76382A75BF37C3@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:0vjtlnIXRQcZt8KzozUWnoUfkHkp6fz4L0oK1lVGPm+
 +nZtsWcDPolVBC+TroNoWUihmPXkKuJi9hlL4jkGqO0SGlIYyJ
 8J+JLoGBH5XX4Ph/kFSttqCj5M34tI+QDs4GfMTQHgWxZAMv6e
 Z6GJBx69Q+62bUhY4vWrMbUY84oYHIFTaarna0Qcazg5PN2x/6
 OeSDUqmqEePw5rHjPcFse5wX3yqHWjvPKMjViZgMlQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Andrew Chew wrote:

> > > +	/* Width must be a multiple of 4 pixels. */
> > > +	*width += *width % 4;
> > 
> > No, this doesn't make it a multiple of 4, unless it was 
> > even;) Just take 5 
> > as an example. What you really want here is
> 
> Geez, you're right.  Not sure what was going on in my head when I did this.  Thanks for catching it.
> 
> 
> > > +	/*
> > > +	 * Try to use as much of the sensor area as possible 
> > when supporting
> > > +	 * smaller resolutions.  Depending on the aspect ratio of the
> > > +	 * chosen resolution, we can either use the full width 
> > of the sensor,
> > > +	 * or the full height of the sensor (or both if the 
> > aspect ratio is
> > > +	 * the same as 1280x720.
> > > +	 */
> > > +	if ((OV9740_MAX_WIDTH * height) > (OV9740_MAX_HEIGHT * width)) {
> > > +		scale_input_x = (OV9740_MAX_HEIGHT * width) / height;
> > > +		scale_input_y = OV9740_MAX_HEIGHT;
> > >  	} else {
> > > -		dev_err(&client->dev, "Failed to select resolution!\n");
> > > -		return -EINVAL;
> > > +		scale_input_x = OV9740_MAX_WIDTH;
> > > +		scale_input_y = (OV9740_MAX_WIDTH * height) / width;
> > >  	}
> > 
> > I don'z know how this sensor works, but the above two divisions round 
> > down. And these are input sizes. Cannot it possibly lead to 
> > the output 
> > window being smaller, than required? Maybe you have to round 
> > up (hint: 
> > use DIV_ROUND_UP())?
> 
> The intention is to do some ratio math without floating point 
> instructions,

Of course, DIV_ROUND_UP is integer maths only too, as well as (almost) all 
maths in the kernel.

> which resulted in some algebraic twiddling (which is why 
> that math looks so weird).

No, it doesn't look weird, I just wasn't sure, whether your maths would 
work in all situations. The only difference between yours and mine, is 
that yours rounds down, and mine rounds up. So, I'm not sure which one is 
better in this case.

> I think what's there is okay.  If there's 
> any rounding at all (and there shouldn't be any rounding, if "standard" 
> image dimensions are called for), then there's going to be some aspect 
> ratio weirdness no matter which way you round that division.

No, you should be prepared to handle all possible crazy resolution 
requests.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
