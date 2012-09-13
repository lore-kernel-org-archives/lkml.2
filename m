Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2IMHa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:30:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40765 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913Ab2IMH34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:29:56 -0400
Date: Thu, 13 Sep 2012 15:29:44 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] Runtime Interpreted Power Sequences
Message-ID: <20120913072943.GB20959@opensource.wolfsonmicro.com>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
 <4473898.CeAQBgUhKL@percival>
 <20120913071928.GA20959@opensource.wolfsonmicro.com>
 <1378218.yLeQheNFT0@percival>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378218.yLeQheNFT0@percival>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 04:26:34PM +0900, Alex Courbot wrote:
> On Thursday 13 September 2012 15:19:30 Mark Brown wrote:
> > > On Thursday 13 September 2012 14:25:53 Mark Brown wrote:
> > > > It would be sensible to make sure that the framework is done in such a
> > > > way that drivers can use it - there will be drivers (perhaps not display
> > > > ones) that have a known power sequence and which could benefit from the
> > > > ability to use library code to implement it based on the user simply
> > > > supplying named resources.

> > > Not sure I understand what you mean, but things should be working this way
> > > already - regulators and PWMs are acquired by name using the standard
> > > regulator_get() and pwm_get() functions. GPIOs do not, AFAIK, have a way
> > > to be referenced by name so their number is used instead.

> > Right, but the sequencing for enabling them is currently open coded in
> > each driver.

> Mmm then I'm afraid I don't see what you wanted to say initially - could you 
> elaborate?

The driver knows the power sequence.  Having to type the same sequence
into the DT or platform data for each board using the device wouuld be
retarded so we need the drivers to be able to give the sequence to the
library if they're going to be able to reuse it (which is a lot of what
Tomi is talking about).
