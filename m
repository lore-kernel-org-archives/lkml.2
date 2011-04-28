Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab1D1Tsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 15:48:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:49145 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab1D1Tsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 15:48:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,282,1301900400"; 
   d="scan'208";a="739855175"
Subject: Re: [PATCH 2.6.39-rc5] ioremap: Delay sanity check until after a
 successful mapping
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "tim.gardner@canonical.com" <tim.gardner@canonical.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <4DB99D2E.9080106@canonical.com>
References: <4DB99D2E.9080106@canonical.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 28 Apr 2011 12:49:09 -0700
Message-Id: <1304020149.2697.5.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 10:00 -0700, Tim Gardner wrote:
> While tracking down the reason for an ioremap() failure I was
> distracted 
> by the WARN_ONCE() in __ioremap_caller(). Can we move the sanity
> check 
> later in the function until _after_ the mapping has been performed?
> 
> rtg
> -- 
> Tim Gardner tim.gardner@canonical.com
> 
> 
> 
> 
> 
> 
> 
> differences
> between files
> attachment
> (0001-ioremap-Delay-sanity-check-until-after-a-successful-.patch)
> 
> From 31dec327a254888fcd0b6aa963414b09626d3168 Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Thu, 28 Apr 2011 10:07:51 -0600
> Subject: [PATCH] ioremap: Delay sanity check until after a successful
> mapping
> 
> Performing a WARN_ONCE() sanity check before the mapping
> is successful seems pointless if the caller sends bad values.
> A case in point is when the BIOS provides erroneous screen_info values
> causing vesafb_probe() to request an outrageuous size. The
> WARN_ONCE is then wasted on bogosity. Move the warning to a
> point where the mapping has been successfully allocated.
> 
> http://bugs.launchpad.net/bugs/772042

Sounds good to me.

Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>

thanks.

