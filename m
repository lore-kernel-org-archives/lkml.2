Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0JUKbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:31:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54505 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0JUKbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:31:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bruno Randolf <br1@einfach.org>
Subject: Re: [PATCH v3] Add generic exponentially weighted moving average (EWMA) function
Cc: kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com,
        Lars_Ericsson@telia.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101020082336.28281.77747.stgit@localhost6.localdomain6>
References: <20101020082336.28281.77747.stgit@localhost6.localdomain6>
Message-Id: <20101021192658.C8EE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 21 Oct 2010 19:31:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm plaing this a bit and I have to say this doesn't works as I expected
because ewma_init() has very easy confusable.

so, I have one request.


> +/**
> + * ewma_init() - Initialize EWMA parameters
> + * @avg: Average structure
> + * @factor: Factor to use for the scaled up internal value. The maximum value
> + *	of averages can be UINT_MAX/(factor*weight).
> + * @weight: Exponential weight, or decay rate. This defines how fast the
> + * 	influence of older values decreases. Has to be bigger than 1.
> + *
> + * Initialize the EWMA parameters for a given struct ewma @avg.
> + */
> +struct ewma*
> +ewma_init(struct ewma *avg, const unsigned int factor,
> +	  const unsigned int weight)
> +{
> +	WARN_ON(weight <= 1 || factor == 0);
> +	avg->weight = weight;
> +	avg->factor = factor;
> +	return avg;
> +}
> +EXPORT_SYMBOL(ewma_init);

Please initalize avg->internal too.


and nit, I don't understand what you intend by 'const unsigned int'. I think
we can remove this const safely. it's more easy readable.




