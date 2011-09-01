Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1IAPRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:17:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53080 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab1IAPRx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:17:53 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.92.201]
In-Reply-To: <201108310022.43850.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
	<201108310022.43850.rjw@sisk.pl>
Date: Thu, 1 Sep 2011 17:17:51 +0200
Message-ID: <CAORVsuW7rFEN8u7RCpmWJamtG2iUbA_zz3ax4hgBjGAZW9vU=A@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] PM / Domains: Add default power off governor function
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Wed, Aug 31, 2011 at 12:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Add a function deciding whether or not a given PM domain should
> be powered off on the basis of that domain's devices' PM QoS
> constraints.
>
> ---
>  drivers/base/power/domain_governor.c |   96 +++++++++++++++++++++++++++++++++++
>  include/linux/pm_domain.h            |    7 ++
>  2 files changed, 103 insertions(+)
>
> Index: linux/include/linux/pm_domain.h
> ===================================================================
> --- linux.orig/include/linux/pm_domain.h
> +++ linux/include/linux/pm_domain.h
> @@ -49,6 +49,10 @@ struct generic_pm_domain {
>        int (*start_device)(struct device *dev);
>        int (*stop_device)(struct device *dev);
>        bool (*active_wakeup)(struct device *dev);
> +       ktime_t power_off_latency;
> +       ktime_t power_on_latency;
> +       s64 break_even_ns;
> +       s64 min_delta_ns;
How are those values populated? Is there a mechanism that dynamically
updates the values?

>  };
>
>  static inline struct generic_pm_domain *pd_to_genpd(struct dev_pm_domain *pd)
> @@ -64,6 +68,9 @@ struct gpd_link {
>  };
>
>  struct gpd_gov_dev_data {
> +       ktime_t start_latency;
> +       ktime_t suspend_latency;
> +       ktime_t resume_latency;
Same question here.

>        s64 break_even_ns;
>  };
>
...

Regards,
Jean
