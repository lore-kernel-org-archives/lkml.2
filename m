Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2DJFUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:20:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:38053 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab2DJFUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:20:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129001077"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: RE: [PATCH] max17042_battery: fix driver exit function
Thread-Topic: [PATCH] max17042_battery: fix driver exit function
Thread-Index: AQHNC3xnErhAmXsEakusyRSed0Yq3paTm1ZA
Date: Tue, 10 Apr 2012 05:20:33 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD1071B1@BGSMSX102.gar.corp.intel.com>
References: <1332756506-6905-1-git-send-email-ramakrishna.pallala@intel.com>
In-Reply-To: <1332756506-6905-1-git-send-email-ramakrishna.pallala@intel.com>
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

> From: Pallala, Ramakrishna
> Sent: Monday, March 26, 2012 3:38 PM
> To: linux-kernel@vger.kernel.org
> Cc: Anton Vorontsov; Anton Vorontsov; Pallala, Ramakrishna
> Subject: [PATCH] max17042_battery: fix driver exit function
> 
> This patch frees the irq and sets the i2c client data to NULL in driver remove function.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
>  drivers/power/max17042_battery.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
> index abf3400..d4868c5 100644
> --- a/drivers/power/max17042_battery.c
> +++ b/drivers/power/max17042_battery.c
> @@ -721,6 +721,10 @@ static int __devexit max17042_remove(struct i2c_client *client)
>  	struct max17042_chip *chip = i2c_get_clientdata(client);
> 
>  	power_supply_unregister(&chip->battery);
> +	if (client->irq)
> +		free_irq(client->irq, chip);
> +	i2c_set_clientdata(client, NULL);
> +
>  	return 0;
>  }

I have not received any comments for this patch.
Can I assume that this patch is in your merge queue?

Thanks,
Ram
