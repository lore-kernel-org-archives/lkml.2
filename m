Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2ISDBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:01:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50359 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176Ab2ISDBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:01:21 -0400
Date: Tue, 18 Sep 2012 23:01:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alex Courbot <acourbot@nvidia.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v6 0/4] Runtime Interpreted Power Sequences
Message-ID: <20120919030116.GN8832@opensource.wolfsonmicro.com>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
 <4473898.CeAQBgUhKL@percival>
 <20120913071928.GA20959@opensource.wolfsonmicro.com>
 <1378218.yLeQheNFT0@percival>
 <20120913072943.GB20959@opensource.wolfsonmicro.com>
 <5051FAC5.40501@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051FAC5.40501@wwwdotorg.org>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 09:24:53AM -0600, Stephen Warren wrote:
> On 09/13/2012 01:29 AM, Mark Brown wrote:

> > The driver knows the power sequence.  Having to type the same sequence
> > into the DT or platform data for each board using the device wouuld be
> > retarded so we need the drivers to be able to give the sequence to the
> > library if they're going to be able to reuse it (which is a lot of what
> > Tomi is talking about).

> I believe that's trivial to implement. The relevant function is:

Right, that's what I'm saying - the code is mostly there now.

> It's up to the driver whether pseq comes from platform data or is
> hard-coded into the driver (or not provided at all, for the DT case).
> So, the only change needed to convert a "hard-coded" driver to this API
> is to convert the current custom data structure (or code) that describes
> the sequence into a struct platform_power_seq_set.

The framework could still help by providing ways to avoid having to copy
the structure and fill in the blanks for GPIO numbers (and anything else
that is numbered rather than named) by hand.
