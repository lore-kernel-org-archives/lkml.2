Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2JKIY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:24:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2JKIYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:24:24 -0400
Date: Thu, 11 Oct 2012 01:24:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <Cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Message-ID: <20121011082420.GC32175@core.coreip.homeip.net>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
 <1349496603-20775-2-git-send-email-cheiny@synaptics.com>
 <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
 <BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 03:41:41AM +0000, Christopher Heiny wrote:
> Linus Walleij wrote:
> > On Sat, Oct 6, 2012 at 6:09 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
> > 
> > > +#ifdef CONFIG_RMI4_DEBUG
> > > +/**
> > > + * Utility routine to handle writes to read-only attributes.  Hopefully
> > > + * this will never happen, but if the user does something stupid, we
> > > don't
> > > + * want to accept it quietly (which is what can happen if you just put
> > > NULL + * for the attribute's store function).
> > > + */
> > > +static inline ssize_t rmi_store_error(struct device *dev,
> > > +                       struct device_attribute *attr,
> > > +                       const char *buf, size_t count)
> > > +{
> > > +       dev_warn(dev,
> > > +                "WARNING: Attempt to write %d characters to read-only
> > > attribute %s.", +               count, attr->attr.name);
> > > +       return -EPERM;
> > > +}
> > 
> > Here it looks like you're hiding a lot of stuff that should be dev_warn()?
> > Consider my earlier point about dynamic debug.
> 
> In previous patch submissions, we always used these warning functions.
> But in the feedback on those patches, we were asked to just make sysfs
> show/store NULL if the attribute is write/read only.  However, during
> their development process, our customers want to see the warnings if
> the attributes are accessed incorrectly.  So we made these warnings a
> debug option.

I think it is the case when customer is not always right. Given that
the attributes are created with S_IRUGO mask how will we even get these
methods to fire?

-- 
Dmitry
