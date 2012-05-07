Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab2EGTlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:41:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab2EGTlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:41:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [BUGFIX] PM, domain, Fix link checking when add subdomain
Date: Mon, 7 May 2012 21:46:09 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <1336368481-15723-1-git-send-email-ying.huang@intel.com>
In-Reply-To: <1336368481-15723-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205072146.10086.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 07, 2012, Huang Ying wrote:
> Current pm_genpd_add_subdomain() will allow duplicated link between
> master and slave domain.  This patch fixed it.
> 
> Because when current pm_genpd_add_subdomain() checks whether the link
> between the master and slave generic PM domain already exists,
> slave_links instead of master_links of master domain is used.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Thanks for the fix, applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
>  drivers/base/power/domain.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -1378,7 +1378,7 @@ int pm_genpd_add_subdomain(struct generi
>  		goto out;
>  	}
>  
> -	list_for_each_entry(link, &genpd->slave_links, slave_node) {
> +	list_for_each_entry(link, &genpd->master_links, master_node) {
>  		if (link->slave == subdomain && link->master == genpd) {
>  			ret = -EINVAL;
>  			goto out;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

