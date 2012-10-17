Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2JQFju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:39:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:43918 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab2JQFjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:39:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,597,1344236400"; 
   d="scan'208";a="205426219"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] power_supply: Added helper function to get the ps
 object from supplied_to list
Thread-Topic: [PATCH v2] power_supply: Added helper function to get the ps
 object from supplied_to list
Thread-Index: AQHNamBS/PY5TqiHtECZnzOtqcnLipe9fpRQ
Date: Wed, 17 Oct 2012 05:39:37 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD244F71B2@BGSMSX102.gar.corp.intel.com>
References: <1343214037-15238-1-git-send-email-ramakrishna.pallala@intel.com>
In-Reply-To: <1343214037-15238-1-git-send-email-ramakrishna.pallala@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Please ignore the following patch.
 
> This patch adds a helper function in the power supply core to get the power
> supply object from supplied_to list based on power supply attribute.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
>  drivers/power/power_supply_core.c |   19 +++++++++++++++++++
>  include/linux/power_supply.h      |    3 +++
>  2 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/power_supply_core.c
> b/drivers/power/power_supply_core.c
> index ff990d2..5845a76 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -158,6 +158,25 @@ struct power_supply
> *power_supply_get_by_name(char *name)  }
> EXPORT_SYMBOL_GPL(power_supply_get_by_name);
> 
> +struct power_supply *power_supply_get_by_suppliedto(struct power_supply
> *psy,
> +				enum power_supply_property psp, int intval) {
> +	union power_supply_propval ret = {0,};
> +	struct power_supply *pst;
> +	int i;
> +
> +	for (i = 0; i < psy->num_supplicants; i++) {
> +		pst = power_supply_get_by_name(psy->supplied_to[i]);
> +		if (!pst || pst->get_property(pst, psp, &ret))
> +			continue;
> +		if (ret.intval == intval)
> +			return pst;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(power_supply_get_by_suppliedto);
> +
>  int power_supply_powers(struct power_supply *psy, struct device *dev)  {
>  	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers"); diff --
> git a/include/linux/power_supply.h b/include/linux/power_supply.h index
> 0bafbb1..3cfee0c 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -219,6 +219,9 @@ struct power_supply_info {  };
> 
>  extern struct power_supply *power_supply_get_by_name(char *name);
> +extern struct power_supply *power_supply_get_by_suppliedto(
> +				struct power_supply *psy,
> +				enum power_supply_property psp, int intval);
>  extern void power_supply_changed(struct power_supply *psy);  extern int
> power_supply_am_i_supplied(struct power_supply *psy);  extern int
> power_supply_set_battery_charged(struct power_supply *psy);
> --
> 1.7.0.4

