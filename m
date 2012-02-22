Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2BVQ3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:29:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55583 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2BVQ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:28:58 -0500
Date: Wed, 22 Feb 2012 11:29:01 -0500
From: Matt Porter <mporter@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120222162901.GB20411@beef>
References: <1329151422-2146-1-git-send-email-mporter@ti.com>
 <20120214110836.GE15338@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214110836.GE15338@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 11:08:36AM +0000, Russell King - ARM Linux wrote:
> Two more points:
> 
> On Mon, Feb 13, 2012 at 11:43:42AM -0500, Matt Porter wrote:
> > This fixes smsc911x support on platforms using gpmc_smsc911x_init().
> > Commit c7e963f6888816f04d1f5da0e07bec4e0092f227 added the requirement
> 
> Always include the commit summary as well here, so:
> 
> Commit c7e963f6888816 (net/smsc911x: Add regulator support) added the ...

Ok. Addressed in v2.

> > @@ -55,6 +94,11 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *board_data)
> >  
> >  	gpmc_cfg = board_data;
> >  
> > +	if (platform_device_register(&gpmc_smsc911x_regulator) < 0) {
> > +		pr_err("Unable to register smsc911x regulators\n");
> > +		return;
> > +	}
> 
> It's always a good idea to indicate why something failed:
> 
> 	err = platform_device_register(&gpmc_smsc911x_regulator);
> 	if (err < 0) {
> 		pr_err("Unable to register smsc911x regulators: %d\n", err);
> 		return;
> 	}
> 
> so that people can see not only what failed, but also why it failed.

Looks much better, also addressed in v2.

-Matt
