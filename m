Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0L3Xbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 18:31:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:58814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab0L3Xbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:31:31 -0500
Message-Id: <c6d829$q0mkri@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,251,1291622400"; 
   d="scan'208";a="873157490"
Date: Thu, 30 Dec 2010 23:31:27 +0000
To: Jeff Chua <jeff.chua.linux@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Alex Riesen <raa.lkml@gmail.com>
In-Reply-To: <Pine.LNX.4.64.1012301045170.5207@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1012301045170.5207@boston.corp.fedex.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010 10:49:33 +0800 (SGT), Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> 
> On Thu, Dec 30, 2010 at 4:16 AM, Jesse Barnes <jbarnes@virtuousgeek.org> 
> wrote:
> 
> > Randy, Jeff and Alex, does the below help at all?  If so, it may be the
> > minimal fix we want for 2.6.37.
> 
> Jesse,
> 
> Yes, that worked for me. I improved on the patch a bit below.
> 
> Thanks,
> Jeff
> 
> 
> --- a/drivers/gpu/drm/i915/intel_bios.c	2010-12-29 13:35:57.000000000 +0800
> +++ a/drivers/gpu/drm/i915/intel_bios.c	2010-12-30 10:18:39.000000000 +0800
> @@ -262,7 +262,10 @@
>   	if (general) {
>   		dev_priv->int_tv_support = general->int_tv_support;
>   		dev_priv->int_crt_support = general->int_crt_support;
> -		dev_priv->lvds_use_ssc = general->enable_ssc;
> +
> +		/* force disable until we can parse this correctly */
> +		dev_priv->lvds_use_ssc = (IS_GEN5(dev) || IS_GEN6(dev)) ?
> +			0 : general->enable_ssc;

This reveals another bug whereby we don't clear conflicting bits in
PCH_DREF_CONTROL set by the BIOS...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
