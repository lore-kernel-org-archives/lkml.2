Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0DEMad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 08:30:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:42895 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab0DEMa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 08:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,365,1267430400"; 
   d="scan'208";a="786502524"
From: "Wang, Yong Y" <yong.y.wang@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Date: Mon, 5 Apr 2010 20:30:07 +0800
Subject: RE: [PATCH] eeepc-wmi: include slab.h
Thread-Topic: [PATCH] eeepc-wmi: include slab.h
Thread-Index: AcrUaXPwqM9mVazlQkOTwWDM6MPw6gAUfWLQ
Message-ID: <FC2FB65B4D919844ADE4BE3C2BB739AD1E03881D@shsmsx501.ccr.corp.intel.com>
References: <4BB94DC1.5010403@kernel.org>
In-Reply-To: <4BB94DC1.5010403@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Tejun Heo [mailto:tj@kernel.org]
> Sent: Monday, April 05, 2010 10:41 AM
> To: lkml
> Cc: Wang, Yong Y
> Subject: [PATCH] eeepc-wmi: include slab.h
> 
> eeepc-wmi uses kfree() but doesn't include slab.h.  Include it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yong Wang <yong.y.wang@intel.com>
> ---
> Hello,
> 
> I've committed this patch to percpu#slabh branch which breaks implicit
> slab interface availability.  I'm gonna push the branch to Linus
> soonish.
> 
> Thanks.
> 
>  drivers/platform/x86/eeepc-wmi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-wmi.c
> b/drivers/platform/x86/eeepc-wmi.c
> index 2466b7b..9f88226 100644
> --- a/drivers/platform/x86/eeepc-wmi.c
> +++ b/drivers/platform/x86/eeepc-wmi.c
> @@ -27,6 +27,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> +#include <linux/slab.h>
>  #include <linux/input.h>
>  #include <linux/input/sparse-keymap.h>
>  #include <acpi/acpi_bus.h>

<linux/module.h> includes <linux/percpu.h> which in turn includes <linux/slab.h>.
Doesn't it?

Thanks
-Yong

