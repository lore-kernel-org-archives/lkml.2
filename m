Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2EMKHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 06:07:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43839 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2EMKHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 06:07:06 -0400
Date: Sun, 13 May 2012 11:07:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RESEND PATCH v2 1/2] MFD: MAX77693: add MAX77693 MFD driver
Message-ID: <20120513100703.GA706@sirena.org.uk>
References: <4F5EDB01.9070308@samsung.com>
 <4F67D86E.30509@samsung.com>
 <20120511141508.GQ1214@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511141508.GQ1214@sortiz-mobl>
X-Cookie: I'm not proud.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:15:08PM +0200, Samuel Ortiz wrote:
> On Tue, Mar 20, 2012 at 10:07:58AM +0900, Chanwoo Choi wrote:

> > +static int __init max77693_i2c_init(void)
> > +{
> > +	return i2c_add_driver(&max77693_i2c_driver);
> > +}
> > +/* init early so consumer devices can complete system boot */
> > +subsys_initcall(max77693_i2c_init);
> > +
> > +static void __exit max77693_i2c_exit(void)
> > +{
> > +	i2c_del_driver(&max77693_i2c_driver);
> > +}
> > +module_exit(max77693_i2c_exit);

> You could use module_i2c_driver() here.

That doesn't work so well for PMICs yet - since cpufreq still doesn't
use struct device it can't use -EPROBE_DEFER which means that we need
the regulators to register before the cpufreq drivers and currently
we're doing that with the subsys_initcall() hack.  Once cpufreq can
defer probes we should be able to stop doing this, it's the only blocker
at the minute.
