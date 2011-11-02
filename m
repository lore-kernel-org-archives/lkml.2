Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1KBKle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:41:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47423 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483Ab1KBKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:41:29 -0400
Date: Wed, 2 Nov 2011 10:41:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, Tony Lindgren <tony@atomide.com>,
        linux-sh@vger.kernel.org, linux-omap@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] regulator: Provide dummy supply support
Message-ID: <20111102104126.GA2678@opensource.wolfsonmicro.com>
References: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de>
 <20111028215931.GA30366@opensource.wolfsonmicro.com>
 <20111028224757.GG23421@pengutronix.de>
 <201111011350.17425.vapier@gentoo.org>
 <20111101182720.GH10029@opensource.wolfsonmicro.com>
 <20111102100355.GJ23421@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102100355.GJ23421@pengutronix.de>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 11:03:56AM +0100, Sascha Hauer wrote:
> On Tue, Nov 01, 2011 at 06:27:21PM +0000, Mark Brown wrote:

> > As I think I said earlier I'd use the fixed regulator for this, all
> > Sascha's actually doing here is adding a wrapper to simplify
> > registration of that.

> There's one difference between the fixed and the dummy regulator though:
> The fixed regulator has a voltage. The same dummy regulator instance can

No, the voltage is optional.

> be used for all devices which do not have a software controllable
> regulator. I think the same can be done with the fixed regulator aswell,
> but the bogus voltage showing up in the sysfs entry might be confusing
> to users.

I don't think that's a meaningful issue, any in any case it'd be better
practice to fill it in so devices can use the information if they want
to (which really shouldn't be hard

> Another approach to this topic would be to allow a board to explicitely
> bind to the existing dummy regulator, like the following (error path
> should of course be implemented before applying this)

If you know you've got a fixed voltage supply I don't understand why you
wouldn't want to set one up.  There clearly is an actual supply in the
system...
