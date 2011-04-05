Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1DEHek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:34:40 -0400
Received: from kroah.org ([198.145.64.141]:59382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1DEHed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:34:33 -0400
Date: Mon, 4 Apr 2011 21:19:50 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 03/12] Staging: hv: Cleanup irq management
Message-ID: <20110405041950.GB8090@kroah.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300226624-27004-3-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 03:03:34PM -0700, K. Y. Srinivasan wrote:
> Now that vmbus_driver is a  pci driver,
> cleanup the irq allocation mess by using the standard
> irq allocation mechanisms.
> 
> Note that this patch generates an error when the checkpatch
> script is run because of the IRQF_SAMPLE_RANDOM flag used in
> request_irq() function. This interrupt may be the only
> external event this VM will get and consequently if this
> flag (IRQF_SAMPLE_RANDOM) is not  specified, experimentally
> we have shown that the entropy in the VM will very very low.
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> ---
>  drivers/staging/hv/vmbus_drv.c |   28 +++++++++++++---------------
>  1 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index 3d2789b..239b91c 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -17,6 +17,8 @@
>   * Authors:
>   *   Haiyang Zhang <haiyangz@microsoft.com>
>   *   Hank Janssen  <hjanssen@microsoft.com>
> + *
> + * 3/9/2011: K. Y. Srinivasan	- Significant restructuring and cleanup

Changelog comments never belong in the file itself.  If you consider
yourself an author of the file now, then put your name in it with the
others.

thanks,

greg k-h
