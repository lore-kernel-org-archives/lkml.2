Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1IMSKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:10:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59649 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755870Ab1IMSKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:10:32 -0400
Subject: Re: [PATCH 20/20] Staging: hv: netvsc: Rename deviceInfo as
 device_info
From: Joe Perches <joe@perches.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 13 Sep 2011 11:10:31 -0700
In-Reply-To: <1315936796-20662-20-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
	 <1315936796-20662-1-git-send-email-kys@microsoft.com>
	 <1315936796-20662-20-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315937432.25776.9.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 10:59 -0700, K. Y. Srinivasan wrote:
> Rename deviceInfo as device_info.
[]
> diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
[]
> @@ -732,15 +732,15 @@ int rndis_filter_device_add(struct hv_device *dev,
[]
>  	dev_info(&dev->device, "Device MAC %pM link state %s",
>  		 rndis_device->hw_mac_adr,
> -		 ((deviceInfo->link_state) ? ("down\n") : ("up\n")));
> +		 ((device_info->link_state) ? ("down\n") : ("up\n")));

Maybe get rid of the superfluous parentheses too?

	dev_info(&dev->device, "Device MAC %pM link state %s\n",
		 rndis_device->hw_mac_adr,
		 device_info->link_state ? "down" : "up");

Also, struct rndis_device uses
	u32 link_stat;
that is copied into struct netvsc_device_info
	bool link_state;
could you please rationalize the names and types
of those 2 variables?


