Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1L1A1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 19:27:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:14033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1L1A1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 19:27:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="90794861"
Subject: Re: [Fwd: [patch] intel_idle: Delete meaningless
 local_irq_disable() call in intel_idle.c.]
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
        len.brown@intel.com, mingmingx.zhang@intel.com
In-Reply-To: <20111227161034.1969c006.akpm@linux-foundation.org>
References: <1324862905.3860.1.camel@ymzhang>
	 <20111227161034.1969c006.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Wed, 28 Dec 2011 08:27:12 +0800
Message-ID: <1325032032.3860.17.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-27 at 16:10 -0800, Andrew Morton wrote:
> On Mon, 26 Dec 2011 09:28:20 +0800
> Yanmin Zhang <yanmin_zhang@linux.intel.com> wrote:
> 
> > Andrew,
> > 
> > Would you like to accept the patch into your testing tree?
> 
> hm, that's three indel_idle patches which I have now.  Someone wake up
> lenb!
> 
> > intel_idle.c is a bit misleading in a sense that local_irq_disable,it
> 

> I'd suggest adding this as well:
Agree. It'll be clearer.

> 
> --- a/drivers/idle/intel_idle.c~drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call-fix
> +++ a/drivers/idle/intel_idle.c
> @@ -232,6 +232,7 @@ static int get_driver_data(int cstate)
>   * @drv: cpuidle driver
>   * @index: index of cpuidle state
>   *
> + * Must be called under local_irq_disable().
>   */
>  static int intel_idle(struct cpuidle_device *dev,
>  		struct cpuidle_driver *drv, int index)


