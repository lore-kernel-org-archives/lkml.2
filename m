Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2JPG0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:26:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49615 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794Ab2JPG0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:26:14 -0400
Date: Tue, 16 Oct 2012 15:26:05 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Christopher Heiny <Cheiny@synaptics.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
Message-ID: <20121016062603.GG8670@opensource.wolfsonmicro.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
 <1349496603-20775-2-git-send-email-cheiny@synaptics.com>
 <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
 <BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local>
 <CACRpkdY3jctXSBB+SMJ=6k=CcLEsHz4jY8T3db8htcE+zWnJWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY3jctXSBB+SMJ=6k=CcLEsHz4jY8T3db8htcE+zWnJWw@mail.gmail.com>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 05:32:59PM +0200, Linus Walleij wrote:
> On Thu, Oct 11, 2012 at 5:41 AM, Christopher Heiny <Cheiny@synaptics.com> wrote:

> > In previous patch submissions, we always used these warning functions.
> > But in the feedback on those patches, we were asked to just make
> > sysfs show/store NULL if the attribute is write/read only.  However,
> > during their development process, our customers want to see the
> > warnings if the attributes are accessed incorrectly.  So we made
> > these warnings a debug option.

> Basically my stance is that you should not lower yourself to the
> level of others not getting the point of your technical solution
> by making unelegant compromises, what
> you should do is to bring them up to your level so they
> understand that your solution is elegant.

It seems like what you really want to do is add a debug feature to sysfs
which will optionally complain loudly at bad accesses; obviously it's
not something that should be there all the time as running then handling
an error is a perfectly legitimate thing to do.  As with the /CS
handling it'd mean it was handled at an appropriate level and could be
reused elsewhere (it might also help make it clear to your customers why
this is generally bad form).
