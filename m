Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab1LFLZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:25:37 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38045 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1LFLZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:25:35 -0500
Date: Tue, 6 Dec 2011 11:25:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali Roh?r <pali.rohar@gmail.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
Message-ID: <20111206112531.GD17194@sirena.org.uk>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
 <2013134.msetbOSBe8@pali-elitebook>
 <CAMP44s1TrRkcy-xS+fXMyv0FAL1TnsPnnTa=gHSd2=P=iFkSUg@mail.gmail.com>
 <8650361.EbH1hYJT76@pali-elitebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8650361.EbH1hYJT76@pali-elitebook>
X-Cookie: Garbage In, Gospel Out
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 08:25:49AM +0100, Pali Roh?r wrote:
> On Tuesday 06 December 2011 02:12:47 you wrote:

> > Also, I'm not familiar with the regulator interface, but it seems to
> > be meant for real regulators, which have consumers, and based on those
> > consumers's needs the real voltage changes. This battery charger on
> > the other hand doesn't have anything like that. There will be no
> > consumer, and some stuff like the weak battery voltage is not even
> > related to a voltage supply, but rather a threshold that can be
> > configured to change some behavior of the charger, but there's no
> > point in changing it dynamically (or maybe at all).

> If regulator interface is not good, I can change it to some sysfs interface. 
> But bq2415x chip driver is not only rx51 specified, so it should handle all 
> chip capabilities.

It's been used by a few charger drivers not for the voltage regulation
but for the current regulation interface - it does provide an
abstraction allowing the battery driver to vary the current going into
the battery independantly of the thing regulating that current.  This
does depend on what control the charger offers, some are designed to be
more autonomous than others.
