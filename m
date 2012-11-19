Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2KSCmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 21:42:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:48964 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2KSCma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 21:42:30 -0500
Date: Sun, 18 Nov 2012 18:39:21 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com
Subject: Re: [PATCH 4/7] power_supply: add throttle state
Message-ID: <20121119023920.GO29066@lizard.sbx05977.paloaca.wayport.net>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
 <1350578646-3315-5-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350578646-3315-5-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 10:14:03PM +0530, Jenny TC wrote:
> The charger and battery temperature contribute to the
> platform thermal. The only way to control the temperature
> is to control the charging. The charging can be controlled in different
> way. This could be disabling charger, disabling charging, adjusting CC,
> or by adjusting the INLMT. This patch adds a structure to define the
> charger throttle actions. Also this patch adds a throttle_states
> field to the struct power_supply which can be used by the charger
> driver to define it's throttle actions for different states
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
>  include/linux/power_supply.h |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index eea1709..b4eb0af 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -183,6 +183,18 @@ union power_supply_propval {
>  	const char *strval;
>  };
>  
> +enum psy_throttle_action {
> +

No need for this empty line.

> +	PSY_THROTTLE_DISABLE_CHARGER = 0,
> +	PSY_THROTTLE_DISABLE_CHARGING,
> +	PSY_THROTTLE_CC_LIMIT,
> +	PSY_THROTTLE_INPUT_LIMIT,
> +};
> +
> +struct power_supply_throttle {
> +	enum psy_throttle_action throttle_action;
> +	unsigned throttle_val;

Let's be consistent. unsigned int.

> +};

Empty line is needed here.

>  struct power_supply {
>  	const char *name;
>  	enum power_supply_type type;
> @@ -192,6 +204,7 @@ struct power_supply {
>  	char **supplied_to;
>  	unsigned long supported_cables;
>  	size_t num_supplicants;
> +	struct power_supply_throttle *throttle_states;
>  
>  	int (*get_property)(struct power_supply *psy,
>  			    enum power_supply_property psp,
> -- 
> 1.7.9.5
