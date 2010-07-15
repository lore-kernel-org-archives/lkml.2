Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab0GOJjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:39:53 -0400
Received: from stinky.trash.net ([213.144.137.162]:40434 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab0GOJjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:39:51 -0400
Message-ID: <4C3ED764.3060301@trash.net>
Date: Thu, 15 Jul 2010 11:39:48 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Jan Engelhardt <jengelh@medozas.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        herbert@gondor.hengli.com.au
Subject: Re: [PATCHv3] extensions: libxt_CHECKSUM extension
References: <20100711150623.GA7420@redhat.com> <20100711151453.GA7563@redhat.com>
In-Reply-To: <20100711151453.GA7563@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.07.2010 17:14, schrieb Michael S. Tsirkin:
> diff --git a/extensions/libxt_CHECKSUM.c b/extensions/libxt_CHECKSUM.c
> new file mode 100644
> index 0000000..00fbd8f
> --- /dev/null
> +++ b/extensions/libxt_CHECKSUM.c
> @@ -0,0 +1,99 @@
> +/* Shared library add-on to xtables for CHECKSUM
> + *
> + * (C) 2002 by Harald Welte <laforge@gnumonks.org>
> + * (C) 2010 by Red Hat, Inc
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + *
> + * This program is distributed under the terms of GNU GPL v2, 1991
> + *
> + * libxt_CHECKSUM.c borrowed some bits from libipt_ECN.c
> + *
> + * $Id$

Please no CVS IDs.

> + */
> +#include <stdio.h>
> +#include <string.h>
> +#include <stdlib.h>
> +#include <getopt.h>
> +
> +#include <xtables.h>
> +#include <linux/netfilter/xt_CHECKSUM.h>
> +
> +static void CHECKSUM_help(void)
> +{
> +	printf(
> +"CHECKSUM target options\n"
> +"  --checksum-fill			Fill in packet checksum.\n");
> +}
> +
> +static const struct option CHECKSUM_opts[] = {
> +	{ "checksum-fill", 0, NULL, 'F' },
> +	{ .name = NULL }
> +};
> +
> +static int CHECKSUM_parse(int c, char **argv, int invert, unsigned int *flags,
> +                     const void *entry, struct xt_entry_target **target)
> +{
> +	struct xt_CHECKSUM_info *einfo
> +		= (struct xt_CHECKSUM_info *)(*target)->data;
> +
> +	switch (c) {
> +	case 'F':
> +		if (*flags)
> +			xtables_error(PARAMETER_PROBLEM,
> +			        "CHECKSUM target: Only use --checksum-fill ONCE!");

There is a helper function called xtables_param_act for checking double
arguments and printing a standarized error message.

> +		einfo->operation = XT_CHECKSUM_OP_FILL;
> +		*flags |= XT_CHECKSUM_OP_FILL;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
