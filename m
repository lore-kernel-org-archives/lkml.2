Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab2IEVbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:31:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44856 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759553Ab2IEVbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:31:20 -0400
Date: Wed, 05 Sep 2012 17:31:18 -0400 (EDT)
Message-Id: <20120905.173118.1107211725393320514.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        havard@skinnemoen.net, plagnioj@jcrosoft.com, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org, patrice.vilchez@atmel.com
Subject: Re: [PATCH 08/10] net/macb: macb_get_drvinfo: add GEM/MACB suffix
 to differentiate revision
From: David Miller <davem@davemloft.net>
In-Reply-To: <fc701a2ed18198b7a671c55f1e65725f1709509c.1346775479.git.nicolas.ferre@atmel.com>
References: <cover.1346775479.git.nicolas.ferre@atmel.com>
	<fc701a2ed18198b7a671c55f1e65725f1709509c.1346775479.git.nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Wed, 5 Sep 2012 11:00:53 +0200

>  	strcpy(info->driver, bp->pdev->dev.driver->name);
> +	if (macb_is_gem(bp))
> +		strcat(info->driver, " GEM");
> +	else
> +		strcat(info->driver, " MACB");

This is a driver string, which means the software driver, and has
absolutely nothing to do with the exact type of the underlying
physical hardware.

Therefore the these suffixes should be left out of the driver string.
