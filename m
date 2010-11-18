Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0KRKiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:38:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60487 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755876Ab0KRKiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:38:00 -0500
Date: Thu, 18 Nov 2010 10:37:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Joe Perches <joe@perches.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org, bleong@codeaurora.org
Subject: Re: [PATCH 1/2] drivers: regulator: core: use pr_fmt
Message-ID: <20101118103758.GB7233@rakim.wolfsonmicro.main>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
 <1290040194.28741.324.camel@Joe-Laptop>
 <1290040508.16344.532.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290040508.16344.532.camel@c-dwalke-linux.qualcomm.com>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:35:08PM -0800, Daniel Walker wrote:
> On Wed, 2010-11-17 at 16:29 -0800, Joe Perches wrote:

> > > +			pr_err("%s '%s' voltage constraints\n", "invalid",
> > > +				name);

> > Using a separate pointer for invalid and unsupportable
> > doesn't save much text space and is very hard to grep.

> > I think it's more intelligible as:

> > 			pr_err("%s: Invalid voltage constraints\n", name);

> I noticed that also, but I didn't feel like changing it when I did this.

This is some stuff from David Brownell which slipped through in review
and should be removed to just have the string.  His theory is that this
allows the compiler to merge multiple versions of the format string,
resulting in a space saving but given how trivial the saving is and the
impact on legibility it's really not worth it.

>                         printk(KERN_WARNING "%s: could not add regulator_dev"
>                                 " load sysfs\n", __func__);

> I'm not sure what this one was suppose to say.

That's a different thing - someone's just split the string over multiple
lines - the two strings will just be concatenated.
