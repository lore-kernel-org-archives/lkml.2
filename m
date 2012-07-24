Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2GXMwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 08:52:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43445 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2GXMws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 08:52:48 -0400
Date: Tue, 24 Jul 2012 13:52:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH 5/5] i2c: tegra: convert normal suspend/resume to
 *_noirq
Message-ID: <20120724125237.GB22576@sirena.org.uk>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
 <1341919244-23327-6-git-send-email-ldewangan@nvidia.com>
 <500D96E6.4060507@wwwdotorg.org>
 <20120724091358.GK12034@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724091358.GK12034@tbergstrom-lnx.Nvidia.com>
X-Cookie: You buttered your bread, now lie in it.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:13:58PM +0300, Peter De Schrijver wrote:
> On Mon, Jul 23, 2012 at 08:24:38PM +0200, Stephen Warren wrote:

> > IIRC, I proposed it before solely to solve some suspend/resume ordering
> > issues, and Colin Cross NAKd it. These days, deferred probe should make
> > this change unnecessary.

> How does deferred probe solve this? Iirc the problem is that i2c is needed to
> talk to the PMIC, so we need to make sure i2c is shutdown last because drivers
> might want to do regulator control in the suspend function.

With probe deferral the drivers will be after the regulator driver in
the DPM list and so be suspended first.
