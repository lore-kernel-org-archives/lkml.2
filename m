Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab3AFT5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 14:57:55 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62205 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3AFT5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 14:57:53 -0500
Date: Sun, 6 Jan 2013 11:57:48 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130106195748.GA28212@core.coreip.homeip.net>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <1357371910-3164-3-git-send-email-ldewangan@nvidia.com>
 <20130105080658.GA1315@core.coreip.homeip.net>
 <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 08:27:39PM +0100, Thierry Reding wrote:
> On Sat, Jan 05, 2013 at 12:06:58AM -0800, Dmitry Torokhov wrote:
> > On Sat, Jan 05, 2013 at 01:15:08PM +0530, Laxman Dewangan wrote:
> [...]
> > > @@ -735,25 +738,16 @@ static int tegra_kbc_probe(struct platform_device *pdev)
> > >  	spin_lock_init(&kbc->lock);
> > >  	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
> > >  
> > > -	res = request_mem_region(res->start, resource_size(res), pdev->name);
> > > -	if (!res) {
> > > -		dev_err(&pdev->dev, "failed to request I/O memory\n");
> > > -		err = -EBUSY;
> > > -		goto err_free_mem;
> > > -	}
> > > -
> > > -	kbc->mmio = ioremap(res->start, resource_size(res));
> > > +	kbc->mmio = devm_request_and_ioremap(&pdev->dev, res);
> > >  	if (!kbc->mmio) {
> > > -		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> > > -		err = -ENXIO;
> > > -		goto err_free_mem_region;
> > > +		dev_err(&pdev->dev, "Cannot request memregion/iomap address\n");
> > > +		return -EADDRNOTAVAIL;
> > 
> > Erm, no, -EBUSY please.
> 
> EADDRNOTAVAIL is the canonical error for devm_request_and_ioremap()
> failure. The kerneldoc comment in lib/devres.c even gives a short
> example that uses this error code.

I am sorry, but I do not consider a function that was added a little
over a year ago as a canon. If you look at the uses of EADDRNOTAVAIL it
is used predominantly in networking code to indicate that attempted
_network_ address is not available.

Thanks.

-- 
Dmitry
