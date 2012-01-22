Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2AVSNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 13:13:39 -0500
Received: from imr3.ericy.com ([198.24.6.13]:58667 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2AVSNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 13:13:38 -0500
Date: Sun, 22 Jan 2012 10:11:53 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Fabio Estevam <festevam@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2] thermal: thermal_sys: Fix build warning
Message-ID: <20120122181153.GA12212@ericsson.com>
References: <1327249995-18682-1-git-send-email-festevam@gmail.com>
 <1327250761-7071-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1327250761-7071-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 22, 2012 at 11:46:01AM -0500, Fabio Estevam wrote:
> Fix the following build warning:
> 
> drivers/thermal/thermal_sys.c:63: warning: 'thermal_event_seqnum' defined but not used
> 
> ,which happens when CONFIG_NET is not set.
> 
> Move 'thermal_event_seqnum' definition inside the '#ifdef CONFIG_NET'
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

> ---
> Change since v1:
> - Sent corrupted patch in v1, and fixed now
>  drivers/thermal/thermal_sys.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index dd9a574..11f5955 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -60,8 +60,6 @@ static LIST_HEAD(thermal_tz_list);
>  static LIST_HEAD(thermal_cdev_list);
>  static DEFINE_MUTEX(thermal_list_lock);
>  
> -static unsigned int thermal_event_seqnum;
> -
>  static int get_idr(struct idr *idr, struct mutex *lock, int *id)
>  {
>  	int err;
> @@ -1304,6 +1302,8 @@ static struct genl_multicast_group thermal_event_mcgrp = {
>  	.name = THERMAL_GENL_MCAST_GROUP_NAME,
>  };
>  
> +static unsigned int thermal_event_seqnum;
> +
>  int generate_netlink_event(u32 orig, enum events event)
>  {
>  	struct sk_buff *skb;
> -- 
> 1.7.1
> 
