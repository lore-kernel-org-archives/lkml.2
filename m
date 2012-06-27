Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2F0TWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:22:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62240 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab2F0TWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:22:41 -0400
Date: Wed, 27 Jun 2012 12:22:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH v3 4/5] Sysfs: Export VMCSINFO via sysfs
Message-ID: <20120627192236.GB1965@kroah.com>
References: <4FEAC945.50700@cn.fujitsu.com>
 <4FEACA5E.4090009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEACA5E.4090009@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 04:54:54PM +0800, Yanfei Zhang wrote:
> This patch export offsets of fields via /sys/devices/cpu/vmcs/.
> Individual offsets are contained in subfiles named by the filed's
> encoding, e.g.: /sys/devices/cpu/vmcs/0800
> 
> Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  drivers/base/core.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 346be8b..dd05ee7 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -26,6 +26,7 @@
>  #include <linux/async.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/netdevice.h>
> +#include <asm/vmcsinfo.h>

Did you just break the build on all other arches?  Not nice.

> @@ -1038,6 +1039,11 @@ int device_add(struct device *dev)
>  	error = dpm_sysfs_add(dev);
>  	if (error)
>  		goto DPMError;
> +#if defined(CONFIG_KVM_INTEL) || defined(CONFIG_KVM_INTEL_MODULE)
> +	error = vmcs_sysfs_add(dev);
> +	if (error)
> +		goto VMCSError;
> +#endif

Oh my no, that's no way to ever do this, you know better than that,
please fix.

greg k-h
