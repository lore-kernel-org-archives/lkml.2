Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2KPOYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:24:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:1333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab2KPOYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:24:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,265,1352102400"; 
   d="scan'208";a="220659280"
Date: Fri, 16 Nov 2012 16:27:58 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / resources: Use AE_CTRL_TERMINATE to terminate
 resources walks
Message-ID: <20121116142758.GU17774@intel.com>
References: <1453537.D7nc72D9LF@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453537.D7nc72D9LF@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 02:49:10PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Currently acpi_dev_process_resource() returns AE_ABORT_METHOD
> to terminate the acpi_walk_resources() it is called from if
> the .preproc() routine provided by the caller of
> acpi_dev_get_resources() initiating the resources walk returns
> an error code.  It is better to use AE_CTRL_TERMINATE for this
> purpose, however, so do that.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

> ---
>  drivers/acpi/resource.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/acpi/resource.c
> ===================================================================
> --- linux.orig/drivers/acpi/resource.c
> +++ linux/drivers/acpi/resource.c
> @@ -446,7 +446,7 @@ static acpi_status acpi_dev_process_reso
>  		ret = c->preproc(ares, c->preproc_data);
>  		if (ret < 0) {
>  			c->error = ret;
> -			return AE_ABORT_METHOD;
> +			return AE_CTRL_TERMINATE;
>  		} else if (ret > 0) {
>  			return AE_OK;
>  		}
