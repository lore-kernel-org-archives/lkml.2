Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab1ANSdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:33:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10344 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab1ANSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:33:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Fri, 14 Jan 2011 10:33:05 -0800
Subject: Re: [PATCH 1/1] power: bq20z75: add support for charge properties
From: rklein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110114152348.GB30831@oksana.dev.rtsoft.ru>
References: <1294944613-11006-1-git-send-email-rklein@nvidia.com>
	 <20110114152348.GB30831@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 10:32:49 -0800
Message-ID: <1295029969.30634.0.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 07:23 -0800, Anton Vorontsov wrote:
> On Thu, Jan 13, 2011 at 10:50:13AM -0800, rklein@nvidia.com wrote:
> [...]
> > +#define PROP_NEEDS_AMPS(PSP) \
> > +	((PSP == POWER_SUPPLY_PROP_CHARGE_NOW) || \
> > +	 (PSP == POWER_SUPPLY_PROP_CHARGE_FULL) || \
> > +	 (PSP == POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN))
> > +
> > +#define PROP_NEEDS_WATTS(PSP) \
> > +	((PSP == POWER_SUPPLY_PROP_ENERGY_NOW) || \
> > +	 (PSP == POWER_SUPPLY_PROP_ENERGY_FULL) || \
> > +	 (PSP == POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN))
> 
> Ugh. Please, implement it as a function.
> 
> And maybe place it somewhere into linux/power_supply.h?
> 
> Something like this maybe?
> 
> static inline bool power_supply_is_amp_prop(enum power_supply_property psp)
> {
> 	switch (psp) {
> 	case POWER_SUPPLY_PROP_CHARGE_NOW:
> 	case POWER_SUPPLY_PROP_CHARGE_FULL:
> 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
> 	<...>
> 		return 1;
> 	}
> 	return 0;
> }
> 
> Thanks!
> 
Will do, that seems a much smarter idea as this could be reused.

-rhyland

