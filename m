Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2HDON2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 10:13:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58816 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab2HDONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 10:13:25 -0400
Date: Sat, 4 Aug 2012 15:12:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120804141155.GJ10523@opensource.wolfsonmicro.com>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <50170EA0.1010408@wwwdotorg.org>
 <501A338D.7080105@nvidia.com>
 <20120802082157.GA14866@avionic-0098.adnet.avionic-design.de>
 <20120802181111.GM4537@opensource.wolfsonmicro.com>
 <501B2642.4080805@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501B2642.4080805@nvidia.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 10:15:46AM +0900, Alex Courbot wrote:
> On Fri 03 Aug 2012 03:11:12 AM JST, Mark Brown wrote:

> >I missed some of the earlier bits of the thread here but why can't we do
> >device based lookups?

> That is because the phandles would not be properties of the device
> node but rather of its sub-nodes:

> backlight {
>     compatible = "pwm-backlight";
>     ...
>     power-on-sequence {
>         step@0 {
>             regulator = <&backlight_reg>;
>             enable;
>         };
> 

> So here simply using regulator_get on the backlight device would not work.

Ah, right.  DT isn't being terribly helpful here...  I think the thing
I'd expect to work here is that you have a reference back to the supply
property of the backlight device rather than direct to the regulator so
you end up writing "enable supply X" rather than "enable regulator X".

Not quite sure how exactly you'd accomplish that - I guess if
regulator_get() would recursively follow phandles until it hits a node
that'd do the trick?
