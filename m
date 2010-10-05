Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0JES7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:59:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59250 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755238Ab0JES7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:59:32 -0400
Date: Tue, 5 Oct 2010 11:59:43 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Message-ID: <20101005185942.GA22808@opensource.wolfsonmicro.com>
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com>
 <4C862EB3.4080006@compulab.co.il>
 <20100907125335.GD25830@sirena.org.uk>
 <201009091027.18176.marek.vasut@gmail.com>
 <20100909094120.GB1988@rakim.wolfsonmicro.main>
 <4CAACA63.6090202@compulab.co.il>
 <20101005161608.GD19730@core.coreip.homeip.net>
 <20101005164037.GA20555@opensource.wolfsonmicro.com>
 <20101005180703.GD21399@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005180703.GD21399@core.coreip.homeip.net>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 11:07:03AM -0700, Dmitry Torokhov wrote:
> On Tue, Oct 05, 2010 at 09:40:38AM -0700, Mark Brown wrote:

> > I really don't think it's a good idea to add this code to every single
> > regulator using driver - this seems like an enormous waste of time and
> > code complexity cost.  I have suggested several times that we should
> > extend the dummy regulator mode so that boards can enable it from code
> > as well as users enable it from Kconfig, I'm not sure why everyone is so
> > keen on bodging this in drivers.

> It all depends on what instances you expect to encounted more often -
> drivers or boards without regulators...

If the board doesn't use regulators you can just disable the regulator
API at which point it compiles out into stubs which report success -
this has been the case from day one.  There's only an issue if the board
has a regulator configuration which is partially visible to software.
