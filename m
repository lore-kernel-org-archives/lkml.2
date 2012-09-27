Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2I0WJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:09:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58807 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab2I0WJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:09:43 -0400
Date: Thu, 27 Sep 2012 18:09:42 -0400 (EDT)
Message-Id: <20120927.180942.969924012897168294.davem@davemloft.net>
To: haicheng.li@linux.intel.com
Cc: netdev@vger.kernel.org, tshimizu818@gmail.com,
        linux-kernel@vger.kernel.org, haicheng.lee@gmail.com
Subject: Re: [PATCH 1/2] Fix build error caused by broken PCH_PTP module
 dependency.
From: David Miller <davem@davemloft.net>
In-Reply-To: <5060F97F.3040809@linux.intel.com>
References: <506009A4.8000202@linux.intel.com>
	<5060F97F.3040809@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Tue, 25 Sep 2012 08:23:27 +0800

> From 898e3214b3406c620571cedf704719784b0df049 Mon Sep 17 00:00:00 2001
> From: Haicheng Li <haicheng.li@linux.intel.com>
> Date: Mon, 24 Sep 2012 15:52:30 +0800
> Subject: [PATCH 1/2] Fix build error caused by broken PCH_PTP module
> dependency.
> 
> The .config is:
>         CONFIG_PCH_GBE=y
>         CONFIG_PCH_PTP=y
>         CONFIG_PTP_1588_CLOCK=m
> 
> The build error:

Your patch submissions are of a very low quality.

And the main reason is that you microscopically look at problems and
do not investigate how the same thing might be handled elsewhere.

Therefore you will never become accustomed to the proper way problems
are fixed, and the proper way to submit patches.

Look at how other people submit patches, do any other patch submissions
look like your's having all of this metadata in the message body:

> From 898e3214b3406c620571cedf704719784b0df049 Mon Sep 17 00:00:00 2001
> From: Haicheng Li <haicheng.li@linux.intel.com>
> Date: Mon, 24 Sep 2012 15:52:30 +0800
> Subject: [PATCH 1/2] Fix build error caused by broken PCH_PTP module
> dependency.

No, nobody else does this.

As for this specific patch:

> -	depends on PTP_1588_CLOCK_PCH
> +	depends on PTP_1588_CLOCK_PCH = PCH_GBE

This is not the correct way to ensure that the module'ness of one
config option meets the module'ness requirements of another.

The correct way is to say something like "&& (PCH_GBE || PCH_GBE=n)"
