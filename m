Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab1ANPX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:23:58 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53409 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1ANPXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:23:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X7JfnpSuq8mQh87HOrHbxnkpke2SnMqrgITzTM/loK7lNu0IYgrq9L8Wh6Q0cka3Th
         zskQCkeyJS4Bwin6u1W6fH9pa6yYm73hH7ijzZyHuRP/peSASkGVeL8m5HVge2DzfDrQ
         KC/IH12wm7D9eBN8MiwR0YQEAKli/rhXRdL4Q=
Date: Fri, 14 Jan 2011 18:23:48 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: rklein@nvidia.com
Cc: olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] power: bq20z75: add support for charge properties
Message-ID: <20110114152348.GB30831@oksana.dev.rtsoft.ru>
References: <1294944613-11006-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1294944613-11006-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 10:50:13AM -0800, rklein@nvidia.com wrote:
[...]
> +#define PROP_NEEDS_AMPS(PSP) \
> +	((PSP == POWER_SUPPLY_PROP_CHARGE_NOW) || \
> +	 (PSP == POWER_SUPPLY_PROP_CHARGE_FULL) || \
> +	 (PSP == POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN))
> +
> +#define PROP_NEEDS_WATTS(PSP) \
> +	((PSP == POWER_SUPPLY_PROP_ENERGY_NOW) || \
> +	 (PSP == POWER_SUPPLY_PROP_ENERGY_FULL) || \
> +	 (PSP == POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN))

Ugh. Please, implement it as a function.

And maybe place it somewhere into linux/power_supply.h?

Something like this maybe?

static inline bool power_supply_is_amp_prop(enum power_supply_property psp)
{
	switch (psp) {
	case POWER_SUPPLY_PROP_CHARGE_NOW:
	case POWER_SUPPLY_PROP_CHARGE_FULL:
	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
	<...>
		return 1;
	}
	return 0;
}

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
