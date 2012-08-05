Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2HEVun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:50:43 -0400
Received: from gloria.sntech.de ([95.129.55.99]:33713 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab2HEVuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:50:17 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Domains: Only check for errors when calling dev_pm_get_subsys_data
Date: Sun, 5 Aug 2012 23:50:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201208052225.09503.heiko@sntech.de> <201208052313.47024.rjw@sisk.pl>
In-Reply-To: <201208052313.47024.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201208052350.10113.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 5. August 2012, 23:13:46 schrieb Rafael J. Wysocki:
> On Sunday, August 05, 2012, Heiko Stübner wrote:
> > Commit 1d5fcfec22 (PM / Domains: Add device domain data reference
> > counter) added a check for the return value of dev_pm_get_subsys_data.
> > 
> > But this function does not only return error codes but also "1" when a
> > new object has been created.
> > 
> > So, change the check to only catch real errors.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> Good catch!

it bit me while moving to 3.6-rc1 with my machine support - suddenly my usbphy 
didn't turn on again :-)

 
> Applied to the linux-next branch of the linux-pm.git tree.  I'm going to
> push it as a fix for v3.6.
> 
> However, there's one more analogous fix necessary, for which I'm going to
> apply the appended patch.

Sorry :-) - I did only check the rest of 1d5fcfec22 for more of this, but not 
the whole domain.c. The second occurence seems to have been introduced by 
62d4490294.


Heiko

> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Domains: Fix one more dev_pm_get_subsys_data() return value
> check
> 
> The check agains the return value of dev_pm_get_subsys_data()
> in pm_genpd_add_callbacks() should be modified so that non-negative
> values are not regarded as errors, because dev_pm_get_subsys_data()
> returns 1 if it successfully creates a new object.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/domain.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/base/power/domain.c
> ===================================================================
> --- linux.orig/drivers/base/power/domain.c
> +++ linux/drivers/base/power/domain.c
> @@ -1691,7 +1691,7 @@ int pm_genpd_add_callbacks(struct device
>  	device_pm_lock();
> 
>  	ret = dev_pm_get_subsys_data(dev);
> -	if (ret)
> +	if (ret < 0)
>  		goto out;
> 
>  	spin_lock_irq(&dev->power.lock);

