Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030854Ab2I1TOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:14:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60014 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030581Ab2I1TOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:14:35 -0400
Date: Fri, 28 Sep 2012 12:11:52 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 18/57] power: Add sysfs interfaces for capacity
Message-ID: <20120928191152.GA28243@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-19-git-send-email-mathieu.poirier@linaro.org>
 <20120927070815.GI8836@lizard>
 <5065EBC0.2010105@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5065EBC0.2010105@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:26:08PM -0600, Mathieu Poirier wrote:
> On 12-09-27 01:08 AM, Anton Vorontsov wrote:
> > On Tue, Sep 25, 2012 at 10:12:15AM -0600, mathieu.poirier@linaro.org wrote:
> >> From: Daniel WILLERUD <daniel.willerud@stericsson.com>
> >>
> >> Switchable depending on whether capacity scaling is enabled
> >>
> >> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> >> Signed-off-by: Daniel WILLERUD <daniel.willerud@stericsson.com>
> >> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> >> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> >> ---
> >>  drivers/power/ab8500_fg.c |   57 ++++++++++++++++++++++++++++++++++++++++++++-
> >>  1 files changed, 56 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> >> index 8507254..46010ec 100644
> >> --- a/drivers/power/ab8500_fg.c
> >> +++ b/drivers/power/ab8500_fg.c
> >> @@ -266,7 +266,6 @@ static enum power_supply_property ab8500_fg_props[] = {
> >>  	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
> >>  	POWER_SUPPLY_PROP_CHARGE_FULL,
> >>  	POWER_SUPPLY_PROP_CHARGE_NOW,
> >> -	POWER_SUPPLY_PROP_CAPACITY,
> > [...]
> >> +static struct device_attribute ab8500_fg_sysfs_psy_attrs[] = {
> >> +	__ATTR(capacity, S_IRUGO, ab8500_show_capacity, NULL),
> >> +};
> > 
> > I don't understand the rationale behind this patch. Why remove normal
> > power supply property, and make your own with the same name? Something
> > isn't right...
> 
> The similarity in the naming convention it a coincidence here.  In one
> case it's a enum and the other sysfs attribute.  Could you expand on
> your suspicions ?

>From the userland point of view, how would the new attribute look like?

Originally the driver reported capacity via power supply class, i.e.
PROP_CAPACITY, now you change to your own attribute.. so the question is
why you do this.

If you need optional attributes, it is still possible to make this w/o
introducing your own attributes mechanisms.

Thanks,
Anton.
