Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1BCGxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 01:53:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45626 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1BCGxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 01:53:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xVTLHkRSAh8LtXXtjYDg1A5C/sBOIMn/euTjMOBsOKtVntHq27N3m9WyPLK9WUywOm
         tU8vA06e3EMmNSmUAvU9FfEGDBP3O9fUMEZThvxAbqfTP71II2HbWhkmiDxJ5HRSeKm1
         CBpi1F8gcPXiElkV4IqYA86qBIrLcPufqBI8I=
Date: Wed, 2 Feb 2011 22:53:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Timur Tabi <timur@freescale.com>,
        linux-input@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 12/19] twl4030: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110203065339.GA5592@core.coreip.homeip.net>
References: <20110202195417.228e2656@queued.net>
 <20110202201522.72d37f1e@queued.net>
 <20110203060521.GA25739@core.coreip.homeip.net>
 <20110202223959.244b4a01@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202223959.244b4a01@queued.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 10:39:59PM -0800, Andres Salomon wrote:
> On Wed, 2 Feb 2011 22:05:21 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Wed, Feb 02, 2011 at 08:15:22PM -0800, Andres Salomon wrote:
> > >  static int __devinit twl4030_vibra_probe(struct platform_device
> > > *pdev) {
> > > -	struct twl4030_codec_vibra_data *pdata =
> > > pdev->dev.platform_data;
> > > +	struct twl4030_codec_vibra_data *pdata =
> > > platform_get_drvdata(pdev);
> > 
> > No, device's drvdata belongs to _this_ driver, and it is supposed to
> > manage it and use as it sees fit.
> 
> Right, so it's used to pass data to the probe function; once the probe
> function has obtained the pdata pointer, it's free to do with it what
> it will.
> 
> 
> > 
> > Note platform_set_drvdata(pdev, info) later in this function along
> > with platform_set_drvdata(pdev, NULL) in twl4030_vibra_remove(),
> > which means that with your change you will be able to bind the device
> > only once.
> > 
> 
> Hm, good point; if the driver is reloaded, the pdev that was created by
> mfd-core will have lost the pointer to pdata.
> 
> I wonder if I should be using mfd's driver_data instead. I used
> platform_data because a bunch of drivers had already made use of it to
> pass cell information..

Then they are doing it incorrectly. One possible way is to have parent
device carry relevant data in its drvdata and have children get it from
there.

-- 
Dmitry
