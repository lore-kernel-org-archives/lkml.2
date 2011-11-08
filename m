Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1KHVt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:49:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1KHVtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:49:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH] PM / OPP: Use ERR_CAST inlined function
Date: Tue, 8 Nov 2011 22:52:03 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <1320778667.8062.137.camel@localhost.localdomain>
In-Reply-To: <1320778667.8062.137.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111082252.04069.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 08, 2011, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
> 
>  Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
> 
>  The semantic patch that makes this change is available
>  in scripts/coccinelle/api/err_cast.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Applied to linux-pm/pm-fixes, will push to Linus shortly.

Thanks,
Rafael


> ---
> 
> diff -u -p a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> --- a/drivers/base/power/opp.c 2011-11-07 19:37:43.009876832 +0100
> +++ b/drivers/base/power/opp.c 2011-11-08 09:55:51.808539048 +0100
> @@ -669,7 +669,7 @@ struct srcu_notifier_head *opp_get_notif
>  	struct device_opp *dev_opp = find_device_opp(dev);
>  
>  	if (IS_ERR(dev_opp))
> -		return ERR_PTR(PTR_ERR(dev_opp)); /* matching type */
> +		return ERR_CAST(dev_opp); /* matching type */
>  
>  	return &dev_opp->head;
>  }
> 
> 
> 
> 

