Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab2FRGVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:21:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2FRGVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:21:04 -0400
Date: Sun, 17 Jun 2012 23:19:16 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org, durgadoss.r@intel.com
Subject: Re: [PATCHv2] power_supply: Register battery as a thermal zone
Message-ID: <20120618061916.GA27786@lizard>
References: <1336576007-8772-1-git-send-email-jenny.tc@intel.com>
 <20120618042927.GA25372@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120618042927.GA25372@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 09:29:28PM -0700, Anton Vorontsov wrote:
[...]
> +static int psy_register_thermal(struct power_supply *psy)
> +{
> +	int i;
> +
> +	/* Register battery zone device psy reports temperature */
> +	for (i = 0; i < psy->num_properties; i++) {
> +		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
> +			psy->tzd = thermal_zone_device_register(psy->name, 0,

Oh, and just FYI, there was a (char *) cast for psy->name, but
I removed it. The cast should be not needed w/ this patch:

http://lkml.org/lkml/2012/6/18/28

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
