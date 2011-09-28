Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1I1HjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:39:17 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:54145 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab1I1HjQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:39:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110928171835.ba767809909ac049fc53bd40@canb.auug.org.au>
References: <20110928171835.ba767809909ac049fc53bd40@canb.auug.org.au>
Date: Wed, 28 Sep 2011 09:39:15 +0200
Message-ID: <CAN5iSWrBOJJEe95-PypGqOfuwd3wDixCZPPi3mJHwCh=MTBhQA@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the moduleh tree
From: "Pihet-XID, Jean" <j-pihet@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Sep 28, 2011 at 9:18 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Paul,
>
> After merging the moduleh tree, today's linux-next build (powerepc
> ppc64_defconfig) produced this warning:
>
> drivers/base/power/qos.c:256:1: warning: data definition has no type or storage class
> drivers/base/power/qos.c:256:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/base/power/qos.c:256:1: warning: parameter names (without types) in function declaration
> drivers/base/power/qos.c:301:1: warning: data definition has no type or storage class
> drivers/base/power/qos.c:301:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/base/power/qos.c:301:1: warning: parameter names (without types) in function declaration
> drivers/base/power/qos.c:342:1: warning: data definition has no type or storage class
> drivers/base/power/qos.c:342:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/base/power/qos.c:342:1: warning: parameter names (without types) in function declaration
> drivers/base/power/qos.c:369:1: warning: data definition has no type or storage class
> drivers/base/power/qos.c:369:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/base/power/qos.c:369:1: warning: parameter names (without types) in function declaration
> drivers/base/power/qos.c:397:1: warning: data definition has no type or storage class
> drivers/base/power/qos.c:397:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/base/power/qos.c:397:1: warning: parameter names (without types) in function declaration
> drivers/base/power/qos.c:412:1: warning: data definition has no type or storage class
> drivers/base/power/qos.c:412:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/base/power/qos.c:412:1: warning: parameter names (without types) in function declaration
> drivers/base/power/qos.c:427:1: warning: data definition has no type or storage class
> drivers/base/power/qos.c:427:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/base/power/qos.c:427:1: warning: parameter names (without types) in function declaration
>
> Caused by commits 91ff4cb803df ("PM QoS: Implement per-device PM QoS
> constraints") and b66213cdb002 ("PM QoS: Add global notification
> mechanism for device constraints") from the pm tree interacting with the
> module.h split up.
>
> I added the following merge fixup patch.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 28 Sep 2011 17:15:52 +1000
> Subject: [PATCH] PM QoS: include export.h in qos.c for EXPORT_SYMBOL
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Thank you for fixing this. I am sorry the warning did not show up
during the OMAP and x86 builds, probably due to the different set of
includes for those platforms.

Regards,
Jean

> ---
>  drivers/base/power/qos.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/power/qos.c b/drivers/base/power/qos.c
> index f9215e8..7f78682 100644
> --- a/drivers/base/power/qos.c
> +++ b/drivers/base/power/qos.c
> @@ -39,6 +39,7 @@
>  #include <linux/slab.h>
>  #include <linux/device.h>
>  #include <linux/mutex.h>
> +#include <linux/export.h>
>
>
>  static DEFINE_MUTEX(dev_pm_qos_mtx);
> --
> 1.7.6.3
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
