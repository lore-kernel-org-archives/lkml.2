Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1H3QFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:05:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44617 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1H3QFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:05:08 -0400
Date: Tue, 30 Aug 2011 18:05:03 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH 1/3] regulator: tps65910: fix device initialisation
Message-ID: <20110830160503.GA20295@localhost>
References: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
 <1314549177.3666.3.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314549177.3666.3.camel@odin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 05:32:57PM +0100, Liam Girdwood wrote:
> Hi Johan,
> 
> On Mon, 2011-08-15 at 12:45 +0200, Johan Hovold wrote:
> > Fix regression introduced by commit
> > a320e3c3d6351814afa5182159df88d2637e0f6f (regulator: tps65911: Add new
> > chip version) which broke probe for all devices:
> > 
> > 	"Invalid tps chip version"
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > ---
> >  drivers/regulator/tps65910-regulator.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
> > index 55dd4e6..bc5ed25 100644
> > --- a/drivers/regulator/tps65910-regulator.c
> > +++ b/drivers/regulator/tps65910-regulator.c
> > @@ -898,9 +898,11 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
> >  	case TPS65910:
> >  		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
> >  		info = tps65910_regs;
> > +		break;
> >  	case TPS65911:
> >  		pmic->get_ctrl_reg = &tps65911_get_ctrl_register;
> >  		info = tps65911_regs;
> > +		break;
> >  	default:
> >  		pr_err("Invalid tps chip version\n");
> >  		return -ENODEV;
> 
> Couldn't apply these as it seems there may already be fixes to some of
> the issues fixed by your patches. Could you update and resend.

It seems patches 1 and 2 are subsumed by Axel Lin's
d04156bca629740a661fd0738cd69ba1f08b2b20 (regulator: tps65910: Add
missing breaks in switch/case), but this one was not marked for stable
even though it fixes a regression for tps65910 devices.

I'll send an updated patch 3 in a minute.

Thanks,
Johan
