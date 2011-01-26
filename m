Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1AZDo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 22:44:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53850
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051Ab1AZDo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 22:44:58 -0500
Date: Tue, 25 Jan 2011 19:45:32 -0800 (PST)
Message-Id: <20110125.194532.71125517.davem@davemloft.net>
To: thomas@wytron.com.tw
Cc: grant.likely@secretlab.ca, nico@fluxnic.net, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] smc91x: add devicetree support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295957508-2701-1-git-send-email-thomas@wytron.com.tw>
References: <1295939399-4197-1-git-send-email-thomas@wytron.com.tw>
	<1295957508-2701-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Chou <thomas@wytron.com.tw>
Date: Tue, 25 Jan 2011 20:11:48 +0800

> @@ -2394,6 +2395,13 @@ static int smc_drv_resume(struct device *dev)
>  	return 0;
>  }
>  
> +static const struct of_device_id smc91x_match[] = {
> +	{ .compatible = "smsc,lan91c94", },
> +	{ .compatible = "smsc,lan91c111", },
> +	{},
> +}
> +MODULE_DEVICE_TABLE(of, smc91x_match);
> +
>  static struct dev_pm_ops smc_drv_pm_ops = {
>  	.suspend	= smc_drv_suspend,
>  	.resume		= smc_drv_resume,

You should not unconditionally put the 'of' device table into the
module image, otherwise the module will be marked as being able to
support OF based devices but the code to support that won't actually
be comiled into the module.
