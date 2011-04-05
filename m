Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1DEHgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:36:11 -0400
Received: from kroah.org ([198.145.64.141]:59555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab1DEHgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:36:09 -0400
Date: Mon, 4 Apr 2011 22:00:45 -0700
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: haiyangz@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH 07/07] Replaced printk with pr_info in hv_timesource
Message-ID: <20110405050045.GA4663@kroah.com>
References: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
 <1301432330-1705-8-git-send-email-hjanssen@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301432330-1705-8-git-send-email-hjanssen@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 01:58:50PM -0700, Hank Janssen wrote:
> Replaced printk in hv_timesource with pr_ calls
> 
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> ---
>  drivers/staging/hv/hv_timesource.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_timesource.c b/drivers/staging/hv/hv_timesource.c
> index a7ee533..0efb049 100644
> --- a/drivers/staging/hv/hv_timesource.c
> +++ b/drivers/staging/hv/hv_timesource.c
> @@ -20,6 +20,7 @@
>   * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
>   *
>   */
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/version.h>
>  #include <linux/clocksource.h>
> @@ -91,7 +92,7 @@ static int __init init_hv_clocksource(void)
>  	if (!dmi_check_system(hv_timesource_dmi_table))
>  		return -ENODEV;
>  
> -	printk(KERN_INFO "Registering HyperV clock source\n");
> +	pr_info("Registering HyperV clock source\n");

Why is this line even needed at all?  Please remove it in future
patches.

thanks,

greg k-h
